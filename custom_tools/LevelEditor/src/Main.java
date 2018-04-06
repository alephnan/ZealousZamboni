import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.FileImageInputStream;
import javax.swing.ImageIcon;
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
	public static final String TILE_IMG = "../../ZealousZamboni/media/lake/tilesheetoutline.png";
	//public static final String TILE_IMG = "../../ZealousZamboni/media/lake/snow_tiles2.png";
	//public static final String TILE_IMG = "../../ZealousZamboni/media/rink_tiles5.png";
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
			FileInputStream fis = new FileInputStream(new File(TILE_IMG));
			BufferedImage img = ImageIO.read(fis);
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
					BufferedImage piece = new BufferedImage(TILE_SIZE,TILE_SIZE,img.getType());
					Graphics2D g = piece.createGraphics();
					g.drawImage(img, 0, 0, TILE_SIZE, TILE_SIZE, TILE_SIZE * j, TILE_SIZE *i,
							TILE_SIZE*j+TILE_SIZE, TILE_SIZE*i+TILE_SIZE, null);
					arr[i*numColumns + j] = new ImageIcon(piece);
					
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
