import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.WindowConstants;


public class Main {
	private static final int TILE_WIDTH = 40;
	private static final int TILE_HEIGHT = 30;
	
	public static void main(String[] args) {
		int w = TILE_WIDTH;
		int h = TILE_HEIGHT;
		if (args.length == 2) {
			// use default values
			w = Integer.parseInt(args[0]);
			h = Integer.parseInt(args[1]);
		}
		JFrame le = new LevelEditor(w, h);
		le.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		le.setPreferredSize(new Dimension(600, 500));
		le.pack();
		le.setVisible(true);
	}
}

@SuppressWarnings("serial")
class LevelEditor extends JFrame {

	
	private static final Color WALL = Color.BLACK;
	private static final Color ICE = Color.WHITE;
	private static final Color BLOCK = Color.RED;
	private static final Color SKATER_ENTRANCE = Color.GREEN;
	
	private static final String FILENAME = "enter filename here";
	
	private JButton[] buttonArray;
	private JTextField filenameField;
	
	public LevelEditor(final int tileWidth, final int tileHeight) {
		
		// add color labels
		JPanel colorLabels = new JPanel();
		colorLabels.setLayout(new GridLayout(1, 4));
		colorLabels.add(new JLabel("Wall  = BLACK"));
		colorLabels.add(new JLabel("Ice   = WHITE"));
		colorLabels.add(new JLabel("Block = Red"));
		colorLabels.add(new JLabel("Entrance = GREEN"));
		this.add(colorLabels, BorderLayout.NORTH);
		
		// add "done" button and filename text field
		JPanel donePanel = new JPanel();
		JButton doneButton = new JButton("Done!");
		doneButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				StringBuilder sb = new StringBuilder();
				for (int i = 0, numTiles = tileWidth*tileHeight; i < numTiles; ++i) {
					sb.append(getColorNum(buttonArray[i]));
					if ((i + 1) % tileWidth == 0)
						sb.append("\n");
					else
						sb.append(", ");
				}
				String csv = sb.toString();
				String filename = filenameField.getText();
				if (filename == null || filename.equals(FILENAME)) {
					filename = "temp.txt";
				} else if (!filename.endsWith(".txt")) {
					filename += ".txt";
				}
				
				Writer w = null;
				try {
					w = new BufferedWriter(new OutputStreamWriter(
							new FileOutputStream(filename), "utf-8"), csv.length());
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
		});
		donePanel.add(doneButton, BorderLayout.LINE_END);
		
		filenameField = new JTextField();
		filenameField.setText(FILENAME);
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
