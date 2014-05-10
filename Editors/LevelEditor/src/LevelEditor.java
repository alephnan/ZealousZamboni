import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;


@SuppressWarnings("serial")
class LevelEditor extends JFrame implements MouseMotionListener{
	
	// This is the path to the resources directory in our zamboni code
	public static final String PATH = "../../ZealousZamboni/res/";
	
	// GUI strings
	private static final String FILEMSG = "enter filename here";
	private static final String FILE_ERR = "Filename error!";
	private static final String FILENAME_INVALID = "Invalid filename: ";
	private static final String FILE_EXISTS = "This file already exists: ";
	private static final String FILE_DNE = "This file does not exist: ";
	private static final String TRY_AGAIN = "\nPlease try again.";
	
	private int tileWidth;
	private int tileHeight;
	private int cursorWidth = 1;
	private int cursorHeight = 1;
	private File editFile;
	private GridButton[][] buttonArray;
	private JTextField filenameField;
	//selection index range -- end > start, includes start excludes end
	private RangeList selectedTileRanges;
	private JTextField[] rangeArray;
	private int x, y;
	JPanel buttonPanel;
	private GridButtonListener buttListener;
	
	private final ImageIcon[] icons;
	
	public LevelEditor(final ImageIcon[] icons) {
		this.icons = icons;
		//this.addMouseMotionListener(this);	//no comment
		selectedTileRanges = RangeList.DEFAULT;
		rangeArray = new JTextField[4];
		for (int i = 0; i < rangeArray.length; ++i) {
			rangeArray[i] = new JTextField("0");
		}
		
		// yes = 0, no = 1
		int n = JOptionPane.showConfirmDialog(this, "Would you like to edit an existing tilemap?", "", JOptionPane.YES_NO_CANCEL_OPTION);
		if (n == 0) {	// yes
			File f = null;
			while (f == null) {
				String s = (String) JOptionPane.showInputDialog(this, 
						"Enter the filename of the file you want to edit "
						+ "(do not include the path to the resources folder)", 
						"Open file", JOptionPane.PLAIN_MESSAGE, null, null, "");
				if (s != null && s != "") {
					s = PATH + s;
					f = new File(s);
					if (!f.exists()) {
						f = null;
						if (!s.endsWith(".txt")) {
							s += ".txt";
							f = new File(s);
							if (!f.exists()) {
								String message = FILE_DNE + "\"" + s + "\"" + TRY_AGAIN;
								JOptionPane.showMessageDialog(LevelEditor.this, message, FILE_ERR, JOptionPane.ERROR_MESSAGE);
								f = null;
							}
						}
					}
				} else {
					String message = FILENAME_INVALID + "\"" + s + "\"" + TRY_AGAIN;
					JOptionPane.showMessageDialog(LevelEditor.this, message, FILE_ERR, JOptionPane.ERROR_MESSAGE);
				}
			}
			editFile = f;
		} else if (n == 1) {		// no
			editFile = null;
			/*String width = (String) JOptionPane.showInputDialog(this, "Enter tilemap width: ", "Tilemap Width", 
					JOptionPane.PLAIN_MESSAGE, null, null, "80");
			String height = (String) JOptionPane.showInputDialog(this, "Enter tilemap height: ", "Tilemap Height", 
					JOptionPane.PLAIN_MESSAGE, null, null, "60");*/
			try {
				tileWidth = Integer.parseInt("80");
				tileHeight = Integer.parseInt("60");
			} catch (NumberFormatException e) {
				tileWidth = Main.TILE_WIDTH;
				tileHeight = Main.TILE_HEIGHT;
			}
		} else {
			System.exit(0);
		}
		
		// add "done" button and filename text field
		JPanel donePanel = new JPanel();
		JButton doneButton = new JButton("Done!");
		doneButton.addActionListener(new ActionListener() {
			
			/* When the user is done, a CSV file is generated with the
			 * tilemap info specified on the GUI
			 */
			public void actionPerformed(ActionEvent e) {
				if (editFile == null) {
					// First, make sure filename is valid and doesn't already exist
					String filename = filenameField.getText();
					String fileErr = filename;	// copy of orig name for error messages
					File f = null;
					if ((filename = checkFilename(filename)) == null) {
						// User did not enter a valid filename
						String message = FILENAME_INVALID + "\"" + fileErr + "\"" + TRY_AGAIN;
						JOptionPane.showMessageDialog(LevelEditor.this, message, FILE_ERR, JOptionPane.ERROR_MESSAGE);
					} else if ((f = checkValidFile(filename)) == null) {
						// Filename already exists
						String message = FILE_EXISTS + "\"" + fileErr + "\"" + TRY_AGAIN;
						JOptionPane.showMessageDialog(LevelEditor.this, message, FILE_ERR, JOptionPane.ERROR_MESSAGE);
					} else {
						// Everything is good, go ahead and write csv file
						prepAndWriteFile(f);
					}
				} else {
					prepAndWriteFile(editFile);
				}
			}
		});
		
		// button panel to hold all of the buttons
		buttonPanel = new JPanel();
		buttonPanel.setBackground(Color.BLACK);
		
		
		if (editFile == null) {
			
			// done panel
			filenameField = new JTextField();
			donePanel.add(doneButton, BorderLayout.LINE_END);
			donePanel.add(filenameField, BorderLayout.LINE_START);
			this.add(donePanel, BorderLayout.SOUTH);
			filenameField.setText(FILEMSG);
			
			buttonArray = new GridButton[tileHeight][tileWidth];
			buttonPanel.setLayout(new GridLayout(tileHeight, tileWidth));
			buttListener = new GridButtonListener();
			for(int i = 0;i<tileHeight;i++)
				for (int j = 0; j < tileWidth; ++j) {
					GridButton next = new GridButton(0);
					next.setPreferredSize(new Dimension(Main.TILE_SIZE, Main.TILE_SIZE));
					next.addMouseMotionListener(this);
					next.addActionListener(buttListener);
					next.setIcon(icons[0]);
					
					// add action listener to change color
					
					buttonPanel.add(next);
					buttonArray[i][j] = next;
				}
		} else {
			// done panel (done button only)
			this.add(doneButton, BorderLayout.SOUTH);
			BufferedReader r = null;
			try {
				r = new BufferedReader(new InputStreamReader(
						new FileInputStream(editFile), "utf-8"));
				List<String> rows = new ArrayList<String>();
				
				String s = null;
				while ((s = r.readLine()) != null) {
					rows.add(s);
				}
				if (rows.isEmpty()) {
					r.close();
					throw new IllegalStateException("File " + editFile.getName() + " is empty");
				}
				tileHeight = rows.size();
				String[] tiles = rows.get(0).split(", ");
				tileWidth = tiles.length;
				buttonArray = new GridButton[tileHeight][tileWidth];
				buttonPanel.setLayout(new GridLayout(tileHeight, tileWidth));
				int buttonIdx = 0;
				setButtonRow(tiles, buttonPanel, buttonIdx);
				for (int i = 1; i < rows.size(); ++i) {
					buttonIdx = i;
					tiles = rows.get(i).split(", ");
					setButtonRow(tiles, buttonPanel, buttonIdx);
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					r.close();
				} catch (Exception ee){}
			}
		}
		
		this.add(buttonPanel, BorderLayout.CENTER);
		// add range panel to fill in many tiles at a time
				JPanel rangePanel = new JPanel();
				rangePanel.setLayout(new GridLayout(1, 4));
				JPanel from = new JPanel();
				from.setLayout(new GridLayout(2, 2));
				JLabel jl = new JLabel("width ");
				jl.setHorizontalTextPosition(SwingConstants.RIGHT);
				from.add(jl);
				from.add(rangeArray[0]);
				
				jl = new JLabel("height ");
				jl.setHorizontalTextPosition(SwingConstants.RIGHT);
				from.add(jl);
				from.add(rangeArray[2]);
				rangePanel.add(from);
				JButton rangeButton = new JButton("Set");
				rangeButton.addActionListener(new ActionListener() {

					@Override
					public void actionPerformed(ActionEvent arg0) {
						int width = Integer.parseInt(rangeArray[0].getText());
						int height = Integer.parseInt(rangeArray[2].getText());
						cursorWidth = width;
						cursorHeight = height;
					}
					
				});
				rangePanel.add(rangeButton);
				jl = new JLabel(tileWidth + "x" + tileHeight);
				jl.setHorizontalTextPosition(SwingConstants.CENTER);
				
				rangePanel.add(jl);
				this.add(rangePanel, BorderLayout.NORTH);
	}
	
	/**
	 * Returns a File with name 'filename' if one with that filename
	 * does not already exist.
	 * @param filename
	 * @return
	 */
	private File checkValidFile(String filename) {
		File f = new File(filename);
		if (f.exists()) {
			f = null;
		}
		return f;
	}
	
	/**
	 * Returns the string with the correct path and extension
	 * if 'filename' is valid, otherwise returns null.
	 * @param filename
	 * @return
	 */
	private String checkFilename(String filename) {
		if (filename != null && !filename.equals(FILEMSG) && !filename.equals("")) {
			filename = PATH + filename;
			if (!filename.endsWith(".txt"))
				filename += ".txt";
			return filename;
		}
		return null;
	}
	
	private void setButtonRow(String[] tiles, JPanel buttonPanel, int buttonIdx) {
		for (int i = 0; i < tileWidth; ++i) {
			int index = Integer.parseInt(tiles[i]);
			GridButton next = new GridButton(index);
			next.addMouseMotionListener(this);
			next.addActionListener(buttListener);
			next.setIcon(icons[index]);
			next.addActionListener(new GridButtonListener());
			buttonPanel.add(next);
			buttonArray[buttonIdx][i] = next;
		}
	}
	
	private void prepAndWriteFile(File f) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < tileHeight; ++i){
			for(int j = 0; j < tileWidth; j++){
				sb.append(buttonArray[i][j].index);
				if ((j + 1) % tileWidth == 0)
					sb.append("\n");
				else
					sb.append(", ");
			}
		}
		String csv = sb.toString();
		
		Writer w = null;
		try {
			w = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(f, false), "utf-8"), csv.length());
			w.write(csv);
			JOptionPane.showMessageDialog(this, "File "+f.getAbsolutePath()+" saved successfully");
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} finally {
			try {
				w.close();
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
	}
	
	public void setButtonImageRange(RangeList r) {
		selectedTileRanges = r;
	}
	
	class GridButtonListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			Iterator<Integer> itr = selectedTileRanges.iterator();
			//System.out.println(selectedTileRanges);
			for(GridButton clicked : getSelectedButts()){
				int i = itr.next();
				clicked.setIcon(icons[i]);
				clicked.index = i;
			}
			//GridButton clicked = (GridButton) e.getSource();
			
		}
	}
	
	class GridButton extends JButton {
		int index;
		
		public GridButton(int index) {
			super();
			this.index = index;
		}
		
		@Override
		public void paint(Graphics g){
			g.drawImage(((ImageIcon)this.getIcon()).getImage(), 0, 0, getWidth(), getHeight(), null);
		}
	}

	@Override
	public void mouseDragged(MouseEvent arg0) {
		
	}

	@Override
	public void mouseMoved(MouseEvent arg0) {
		this.x = ((JButton)arg0.getSource()).getX()-buttonArray[0][0].getX();
		this.y = ((JButton)arg0.getSource()).getY()-buttonArray[0][0].getY();
		repaint();
	}
	
	@Override
	public void paint(Graphics g){
		super.paint(g);
		g.setColor(Color.yellow);
		for(GridButton b : getSelectedButts()){
			//Need strange offsets to get cursor to line up with actual buttons, not sure why
			g.drawRect(b.getX()+Main.TILE_SIZE,b.getY()+9*Main.TILE_SIZE,b.getWidth(),b.getHeight());
		}
	}
	
	private List<GridButton> selectedButts = new ArrayList<GridButton>();
	private List<GridButton> getSelectedButts(){
		selectedButts.clear();
		int x = this.x/(buttonArray[0][0].getWidth());
		int y = this.y/buttonArray[0][0].getHeight();
		for(int i = y;i<y+cursorHeight;i++)
			for(int j = x;j<x+cursorWidth;j++){
				if(i >= tileHeight || j >= tileWidth) continue;
				selectedButts.add(buttonArray[i][j]);
			}
		return selectedButts;
	}
}