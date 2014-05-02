import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;

import javax.swing.JOptionPane;


public class Main {
	private static final String LEVEL_INFO = "Level Info";
	
	// This is the path to the resources directory in our zamboni code
	public static final String PATH = "../ZealousZamboni/res/";
		
	public static void main(String[] args) {
		boolean valid = false;
		String s = null;
		int numSkaters = 0;
		while (!valid) {
			s = (String) JOptionPane.showInputDialog(null, "Enter the number of skaters: ", LEVEL_INFO, 
					JOptionPane.PLAIN_MESSAGE, null, null, "2");
			try {
				numSkaters = Integer.parseInt(s);
				valid = true;
			} catch (NumberFormatException e) {}
		}
		valid = false;
		s = null;
		int numPowerups = 0;
		while (!valid) {
			s = (String) JOptionPane.showInputDialog(null, "Enter the number of powerups: ", LEVEL_INFO, 
					JOptionPane.PLAIN_MESSAGE, null, null, "2");
			try {
				numPowerups = Integer.parseInt(s);
				valid = true;
			} catch (NumberFormatException e) {}
		}
		
		valid = false;
		s = null;
		int numZombies = 0;
		while (!valid) {
			s = (String) JOptionPane.showInputDialog(null, "Enter the number of zombies: ", LEVEL_INFO, 
					JOptionPane.PLAIN_MESSAGE, null, null, "2");
			try {
				numZombies = Integer.parseInt(s);
				valid = true;
			} catch (NumberFormatException e) {}
		}
		valid = false;
		s = null;
		File f = null;
		String filename = null;
		while (!valid) {
			s = (String) JOptionPane.showInputDialog(null, "Enter the filename you would like to save to: ", LEVEL_INFO, 
					JOptionPane.PLAIN_MESSAGE, null, null, "level_x_form.txt");
			if ((filename = checkFilename(s)) == null) {
				// User did not enter a valid filename
				String message = "Invalid filename: \"" + s + "\", try again";
				JOptionPane.showMessageDialog(null, message, "File Error", JOptionPane.ERROR_MESSAGE);
			} else if ((f = checkValidFile(filename)) == null) {
				// Filename already exists
				String message = "File: \"" + s + "\", try again";
				JOptionPane.showMessageDialog(null, message, "File Error", JOptionPane.ERROR_MESSAGE);
			} else {
				valid = true;
			}
		}
		StringBuilder sb = new StringBuilder();
		levelGenerator(sb);
		sb.append("#Number of skaters:\n");
		sb.append(numSkaters).append("\n");
		for (int i = 0; i < numSkaters; ++i) {
			skaterGenerator(sb, (i+1));
		}
		sb.append("#Number of powerups:\n");
		sb.append(numPowerups).append("\n");
		for (int i = 0; i < numPowerups; ++i) {
			powerupGenerator(sb, (i+1));
		}
		sb.append("#Number of zombies:\n");
		sb.append(numZombies).append("\n");
		for (int i = 0; i < numZombies; ++i) {
			zombieGenerator(sb, (i+1));
		}

		String form = sb.toString();
		
		Writer w = null;
		try {
			w = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(f), "utf-8"), form.length());
			w.write(form);
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
	
	private static void levelGenerator(StringBuilder sb) {
		sb.append("#Number of player lives:\n\n");
		sb.append("#Zamboni start positionX:\n\n");
		sb.append("#Zamboni start positionY:\n\n");
	}
	
	private static void skaterGenerator(StringBuilder sb, int skaterIdx) {
		sb.append("#####Skater" + skaterIdx + "#####\n");
		sb.append("#Skater path type:(LEFT=0 is only option right now)\n");
		sb.append("0\n");
		sb.append("#Skater entrance (NORTH=0 or SOUTH=1):\n\n");
		sb.append("#Skater time on ice (seconds):\n\n");
	}
	
	private static void powerupGenerator(StringBuilder sb, int powerupIdx) {
		sb.append("#####Powerup" + powerupIdx + "#####\n");
		sb.append("#Powerup positionX:\n\n");
		sb.append("#Powerup positionY:\n\n");
		sb.append("#Powerup type (LAWYER=0,HOURGLASS=1,BIGZAMBONI=2):\n\n");
		sb.append("#Powerup time on ice (seconds):\n\n");
	}

	private static void zombieGenerator(StringBuilder sb, int zombieIdx) {
		sb.append("#####Zombie" + zombieIdx + "#####\n");
		sb.append("#Zombie start positionX:\n\n");
		sb.append("#Zombie start positionY:\n\n");
	}
		
		/**
		 * Returns a File with name 'filename' if one with that filename
		 * does not already exist.
		 * @param filename
		 * @return
		 */
		private static File checkValidFile(String filename) {
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
		private static String checkFilename(String filename) {
			if (filename != null && !filename.equals("")) {
				filename = PATH + filename;
				if (!filename.endsWith(".txt"))
					filename += ".txt";
				return filename;
			}
			return null;
		}
}
