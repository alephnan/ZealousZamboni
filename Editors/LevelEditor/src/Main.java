import java.awt.Dimension;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.FileImageInputStream;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
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
	public static final String TILE_IMG = "../../ZealousZamboni/media/rink_tiles5.png";
	
	public static int TILE_SIZE = 8;
	
	public static int IMG_TILE_WIDTH;	//number tiles wide
	public static int IMG_TILE_HEIGHT;	//number tiles high
	
	public static void main(String[] args) {
		System.setProperty("java.util.Arrays.useLegacyMergeSort", "true");
		/*TILE_SIZE = Integer.parseInt((String) JOptionPane.showInputDialog(null, "Tile size: ", 
				"", JOptionPane.PLAIN_MESSAGE, null, null, "8"));*/
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
			IMG_TILE_WIDTH = numColumns;
			int numRows = imageReader.getHeight(0) / TILE_SIZE;
			IMG_TILE_HEIGHT = numRows;
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
