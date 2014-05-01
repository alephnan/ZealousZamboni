import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;

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
	public static final String PATH = "ZealousZamboni/res/";
	
	// GUI strings
	private static final String FILEMSG = "enter filename here";
	private static final String FILE_ERR = "Filename error!";
	private static final String FILENAME_INVALID = "Invalid filename: ";
	private static final String FILE_EXISTS = "This file already exists: ";
	private static final String TRY_AGAIN = "\nPlease try again.";
	
	private static final Color WALL = Color.BLACK;
	private static final Color ICE = Color.WHITE;
	private static final Color BLOCK = Color.RED;
	private static final Color SKATER_ENTRANCE = Color.GREEN;
	
	private int tileWidth;
	private int tileHeight;
	private JButton[] buttonArray;
	private JTextField filenameField;
	
	public LevelEditor() {
		String width = (String) JOptionPane.showInputDialog(this, "Please enter tilemap width: ", "Tilemap Width", 
				JOptionPane.PLAIN_MESSAGE, null, null, "40");
		String height = (String) JOptionPane.showInputDialog(this, "Please enter tilemap height: ", "Tilemap Height", 
				JOptionPane.PLAIN_MESSAGE, null, null, "30");
		try {
			tileWidth = Integer.parseInt(width);
			tileHeight = Integer.parseInt(height);
		} catch (NumberFormatException e) {
			tileWidth = Main.TILE_WIDTH;
			tileHeight = Main.TILE_HEIGHT;
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
								new FileOutputStream(f), "utf-8"), csv.length());
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
			}
		});
		donePanel.add(doneButton, BorderLayout.LINE_END);
		
		filenameField = new JTextField();
		filenameField.setText(FILEMSG);
		donePanel.add(filenameField, BorderLayout.LINE_START);
		this.add(donePanel, BorderLayout.SOUTH);
		
		// add ALL of the buttons
		JPanel buttonPanel = new JPanel();
		
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
			next.addActionListener(new ActionListener() {
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
			});
			buttonPanel.add(next);
			buttonArray[i] = next;
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
}
