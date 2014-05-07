import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
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

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.FileImageInputStream;
import javax.swing.ButtonGroup;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.JToggleButton;
import javax.swing.SwingConstants;
import javax.swing.WindowConstants;

/**
 * A simple GUI to create levels for Zealous Zamboni.
 * @author Dana
 *
 */
public class Main {
	public static final int TILE_WIDTH = 40;
	public static final int TILE_HEIGHT = 30;
	
	// This is the path to the tiles we use in the game
	public static final String TILE_IMG = "../../ZealousZamboni/res/tiles_new.png";
	
	public static int TILE_SIZE = 8;
	
	public static void main(String[] args) {
		System.setProperty("java.util.Arrays.useLegacyMergeSort", "true");
		TILE_SIZE = Integer.parseInt((String) JOptionPane.showInputDialog(null, "Tile size: ", 
				"", JOptionPane.PLAIN_MESSAGE, null, null, "8"));
		ImageIcon[] br = getTiles();
		LevelEditor le = new LevelEditor(br);
		le.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		le.setPreferredSize(new Dimension(800, 600));
		le.pack();
		le.setVisible(true);
		TileOptions to = new TileOptions(br, le);
		to.setPreferredSize(new Dimension(300, 400));
		to.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		to.pack();
		to.setVisible(true);
	}
	
	public static ImageIcon[] getTiles() {
		ImageIcon[] arr = null;
		try {
			FileImageInputStream is = new FileImageInputStream(new File(TILE_IMG));
			ImageReader imageReader = ImageIO.getImageReaders(is).next();
			imageReader.setInput(is, false, true);
			ImageReadParam readParameters = imageReader.getDefaultReadParam();
			int numColumns = imageReader.getWidth(0) / TILE_SIZE;
			int numRows = imageReader.getHeight(0) / TILE_SIZE;
			arr = new ImageIcon[numColumns * numRows];
			
			Dimension d = new Dimension(TILE_SIZE, TILE_SIZE);
			for (int i = 0; i < numRows; ++i) {
				for (int j = 0; j < numColumns; ++j) {
					Rectangle rect = new Rectangle(new Point(j * TILE_SIZE, i * TILE_SIZE), d);
					BufferedImage bi = getTile(rect, imageReader, readParameters);
					arr[i*numColumns + j] = new ImageIcon(bi);
				}
			}
			imageReader.dispose();
			is.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return arr;
	}
	
	private static BufferedImage getTile(Rectangle rect, ImageReader ir, ImageReadParam irp) {
		irp.setSourceRegion(rect);
	    try {
	        BufferedImage bi = ir.read(0, irp);
	        return bi;
	    } catch (IOException ex) {
	        return null;
	    }
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
	
	private int tileWidth;
	private int tileHeight;
	private File editFile;
	private GridButton[] buttonArray;
	private JTextField filenameField;
	private int selectionIndex;
	private JTextField[] rangeArray;
	
	private final ImageIcon[] icons;
	
	public LevelEditor(final ImageIcon[] icons) {
		this.icons = icons;
		selectionIndex = 0;
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
			buttonArray = new GridButton[numTiles];
			buttonPanel.setLayout(new GridLayout(tileHeight, tileWidth));
			for (int i = 0; i < numTiles; ++i) {
				GridButton next = new GridButton(0);
				next.setIcon(icons[0]);
				
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
				buttonArray = new GridButton[tileWidth * tileHeight];
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
		// add range panel to fill in many tiles at a time
				JPanel rangePanel = new JPanel();
				rangePanel.setLayout(new GridLayout(1, 4));
				JPanel from = new JPanel();
				from.setLayout(new GridLayout(2, 2));
				JLabel jl = new JLabel("from x = ");
				jl.setHorizontalTextPosition(SwingConstants.RIGHT);
				from.add(jl);
				from.add(rangeArray[0]);
				
				jl = new JLabel("from y = ");
				jl.setHorizontalTextPosition(SwingConstants.RIGHT);
				from.add(jl);
				from.add(rangeArray[2]);
				
				JPanel to = new JPanel();
				to.setLayout(new GridLayout(2, 2));
				jl = new JLabel("to x = ");
				jl.setHorizontalTextPosition(SwingConstants.RIGHT);
				to.add(jl);
				to.add(rangeArray[1]);
				
				jl = new JLabel("to y = ");
				jl.setHorizontalTextPosition(SwingConstants.RIGHT);
				to.add(jl);
				to.add(rangeArray[3]);
				
				rangePanel.add(from);
				rangePanel.add(to);
				JButton rangeButton = new JButton("Go");
				rangeButton.addActionListener(new ActionListener() {

					@Override
					public void actionPerformed(ActionEvent arg0) {
						int xFrom = Integer.parseInt(rangeArray[0].getText());
						int xTo = Integer.parseInt(rangeArray[1].getText());
						int yFrom = Integer.parseInt(rangeArray[2].getText());
						int yTo = Integer.parseInt(rangeArray[3].getText());
						if (xFrom < 0) xFrom = 0;
						if (yFrom < 0) yFrom = 0;
						if (yTo > tileHeight) yTo = tileHeight;
						if (xTo > tileWidth) xTo = tileWidth;
						for (int i = yFrom; i < yTo; ++i) {
							for (int j = xFrom; j < xTo; ++j) {
								GridButton gb = buttonArray[i*tileWidth+j];
								gb.setIcon(icons[selectionIndex]);
								gb.index = selectionIndex;
							}
						}
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
			next.setIcon(icons[index]);
			next.addActionListener(new GridButtonListener());
			buttonPanel.add(next);
			buttonArray[buttonIdx + i] = next;
		}
	}
	
	private void prepAndWriteFile(File f) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0, numTiles = tileWidth*tileHeight; i < numTiles; ++i) {
			sb.append(buttonArray[i].index);
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
	
	public void setButtonImage(int imageIndex) {
		selectionIndex = imageIndex;
	}
	
	class GridButtonListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			GridButton clicked = (GridButton) e.getSource();
			clicked.setIcon(icons[selectionIndex]);
			clicked.index = selectionIndex;
		}
	}
	
	class GridButton extends JButton {
		int index;
		
		public GridButton(int index) {
			super();
			this.index = index;
		}
	}
}

@SuppressWarnings("serial")
class TileOptions extends JFrame {
	private static final int BUTTON_WIDTH = 5;
	LevelEditor le;
	ButtonGroup group;
	
	public TileOptions(ImageIcon[] icons, final LevelEditor le) {
		this.le = le;
		JPanel buttonPanel = new JPanel();
		JScrollPane scroller = new JScrollPane(buttonPanel, 
				JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, 
				JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
		this.add(scroller);
		
		int buttonHeight = icons.length/BUTTON_WIDTH;
		// rows of 5 images
		if (icons.length % BUTTON_WIDTH != 0) {
			buttonHeight++;
		}
		buttonPanel.setLayout(new GridLayout(buttonHeight, BUTTON_WIDTH));
		group = new ButtonGroup();
		for (int i = 0, len = icons.length; i < len; ++i) {
			JToggleButton b = new TileButton(icons[i], false, i);
			group.add(b);
			b.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					group.clearSelection();
					TileButton tb = (TileButton)e.getSource();
					tb.setSelected(true);
					int index = (tb).index;
					le.setButtonImage(index);
				}
			});
			buttonPanel.add(b);
		}
	}
	
	class TileButton extends JToggleButton {
		int index;
		
		public TileButton(Icon icon, boolean selected, int index) {
			super(icon, selected);
			this.index = index;
		}
	}
}
