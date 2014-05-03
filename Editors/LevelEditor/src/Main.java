import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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
import java.util.List;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.WindowConstants;

/**
 * A simple GUI to create levels for Zealous Zamboni.
 * @author Dana
 *
 */
public class Main {
	public static final int TILE_WIDTH = 40;
	public static final int TILE_HEIGHT = 30;
	
	public static void main(String[] args) {
		JFrame le = new LevelEditor();
		le.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		le.setPreferredSize(new Dimension(600, 500));
		le.pack();
		le.setVisible(true);
	}
}

@SuppressWarnings("serial")
class LevelEditor extends JFrame {
	
	// This is the path to the resources directory in our zamboni code
	public static final String PATH = "../../ZealousZamboni/res/";
	
	// GUI strings
	private static final String FILEMSG = "enter filename here";
	private static final String FILE_ERR = "Filename error!";
	private static final String FILENAME_INVALID = "Invalid filename: ";
	private static final String FILE_EXISTS = "This file already exists: ";
	private static final String FILE_DNE = "This file does not exist: ";
	private static final String TRY_AGAIN = "\nPlease try again.";
	
	private static final Color WALL = Color.BLACK;
	private static final Color ICE = Color.WHITE;
	private static final Color BLOCK = Color.RED;
	private static final Color SKATER_ENTRANCE = Color.GREEN;
	
	private int tileWidth;
	private int tileHeight;
	private File editFile;
	private JButton[] buttonArray;
	private JTextField filenameField;
	
	public LevelEditor() {
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
			String width = (String) JOptionPane.showInputDialog(this, "Enter tilemap width: ", "Tilemap Width", 
					JOptionPane.PLAIN_MESSAGE, null, null, "40");
			String height = (String) JOptionPane.showInputDialog(this, "Enter tilemap height: ", "Tilemap Height", 
					JOptionPane.PLAIN_MESSAGE, null, null, "30");
			try {
				tileWidth = Integer.parseInt(width);
				tileHeight = Integer.parseInt(height);
			} catch (NumberFormatException e) {
				tileWidth = Main.TILE_WIDTH;
				tileHeight = Main.TILE_HEIGHT;
			}
		} else {
			System.exit(0);
		}
		// add color labels
		JPanel colorLabels = new JPanel();
		colorLabels.setLayout(new GridLayout(1, 4));
		colorLabels.add(new JLabel("Wall  = BLACK"));
		colorLabels.add(new JLabel("Ice   = WHITE"));
		colorLabels.add(new JLabel("Block = RED"));
		colorLabels.add(new JLabel("Entrance = GREEN"));
		this.add(colorLabels, BorderLayout.NORTH);
		
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
		JPanel buttonPanel = new JPanel();
		
		
		if (editFile == null) {
			
			// done panel
			filenameField = new JTextField();
			donePanel.add(doneButton, BorderLayout.LINE_END);
			donePanel.add(filenameField, BorderLayout.LINE_START);
			this.add(donePanel, BorderLayout.SOUTH);
			filenameField.setText(FILEMSG);
			
			int numTiles = tileWidth*tileHeight;
			buttonArray = new JButton[numTiles];
			buttonPanel.setLayout(new GridLayout(tileHeight, tileWidth));
			for (int i = 0; i < numTiles; ++i) {
				JButton next = new JButton();
				
				//Preset edges to be walls
				if ((i < tileWidth) || (i >= numTiles - tileWidth) ||
					(i % tileWidth == 0) || ((i+1) % tileWidth == 0)) {
					next.setBackground(WALL);
				} else {
					next.setBackground(ICE);
				}
				
				// add action listener to change color
				next.addActionListener(new GridButtonListener());
				buttonPanel.add(next);
				buttonArray[i] = next;
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
				buttonArray = new JButton[tileWidth * tileHeight];
				buttonPanel.setLayout(new GridLayout(tileHeight, tileWidth));
				int buttonIdx = 0;
				setButtonRow(tiles, buttonPanel, buttonIdx);
				for (int i = 1; i < rows.size(); ++i) {
					buttonIdx = i * tileWidth;
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
	
	private int getColorNum(JButton b) {
		if (b.getBackground().equals(ICE)) {
			return 0;
		} else if (b.getBackground().equals(WALL)) {
			return 1;
		} else if (b.getBackground().equals(BLOCK)) {
			return 2;
		} else {
			return 3;
		}
	}
	
	private Color getColor(int c) {
		if (c == 0) {
			return ICE;
		} else if (c == 1) {
			return WALL;
		} else if (c == 2) {
			return BLOCK;
		} else {
			return SKATER_ENTRANCE;
		}
	}
	
	private void setButtonRow(String[] tiles, JPanel buttonPanel, int buttonIdx) {
		for (int i = 0; i < tileWidth; ++i) {
			JButton next = new JButton();
			next.setBackground(getColor(Integer.parseInt(tiles[i])));
			next.addActionListener(new GridButtonListener());
			buttonPanel.add(next);
			buttonArray[buttonIdx + i] = next;
		}
	}
	
	private void prepAndWriteFile(File f) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0, numTiles = tileWidth*tileHeight; i < numTiles; ++i) {
			sb.append(getColorNum(buttonArray[i]));
			if ((i + 1) % tileWidth == 0)
				sb.append("\n");
			else
				sb.append(", ");
		}
		String csv = sb.toString();
		
		Writer w = null;
		try {
			w = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(f, false), "utf-8"), csv.length());
			w.write(csv);
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
	
	class GridButtonListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			JButton clicked = (JButton) e.getSource();
			if (clicked.getBackground().equals(WALL)) {
				clicked.setBackground(ICE);
			} else if (clicked.getBackground().equals(ICE)) {
				clicked.setBackground(BLOCK);
			} else if (clicked.getBackground().equals(BLOCK)) {
				clicked.setBackground(SKATER_ENTRANCE);
			} else {	// skater entrance
				clicked.setBackground(WALL);
			}
		}
	}
}
