import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Scanner;


public class Main {
	
	// This is the path to the resources directory in our zamboni code
	public static final String PATH = "../../ZealousZamboni/res/";
	// Default frame size (change as needed)
	private static int frameWidth = 640;
	private static int frameHeight = 480;
	
	public static void main(String[] args) {
		if (args.length != 0) {
			frameWidth = Integer.parseInt(args[0]);
			frameHeight = Integer.parseInt(args[1]);
		}
		Scanner input = new Scanner(System.in);
		
		// Get filename
		boolean valid = false;
		File f = null;
		String filename = null;
		while (!valid) {
			System.out.print("Enter a filename to write this XML data to: ");
			String orig = input.next();
			if ((filename = checkFilename(orig)) == null) {
				// User did not enter a valid filename
				System.out.println("Invalid filename: \"" + orig);
			} else if ((f = checkValidFile(filename)) == null) {
				// Filename already exists
				System.out.println("File: \"" + orig + "\" already exists");
			} else {
				valid = true;
			}
		}
		
		// Setup
		StringBuilder sb = new StringBuilder();
		sb.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
		
		// General level info
		System.out.print("Enter the number of player lives: ");
		int x = readInt(input, "(Example: 2)");
		sb.append("<level width=\"" + frameWidth + "\" height=\"" + frameHeight + "\" lives=\"" + x + "\">\n");
		
		// Zamboni
		System.out.print("Enter the zamboni starting X coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		x = readInt(input, "(Example: 160)");
		System.out.print("Enter the zamboni starting Y coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int y = readInt(input, "(Example: 0)");
		sb.append("\t<zamboni x=\"" + x + "\" y=\"" + y + "\"/>\n");
		
		// Skaters
		String s = "";
		do {
			System.out.print("Enter the number of skaters: ");
			x = readInt(input, "(Example: 2)");
			System.out.print("You input " + x + " skaters, is that correct (y/n)");
			s = input.next();
		} while (!s.equals("y"));
		
		for (int i = 0; i < x; ++i) {
			addSkater(input, sb);
		}
		
		// Powerups
		do {
			System.out.print("Enter the number of powerups: ");
			x = readInt(input, "(Example: 2)");
			System.out.print("You input " + x + " powerups, is that correct (y/n)");
			s = input.next();
		} while (!s.equals("y"));
		
		for (int i = 0; i < x; ++i) {
			addPowerup(input, sb);
		}
		
		// Zombies
				do {
					System.out.print("Enter the number of zombies: ");
					x = readInt(input, "(Example: 2)");
					System.out.print("You input " + x + " zombies, is that correct (y/n)");
					s = input.next();
				} while (!s.equals("y"));
				
				for (int i = 0; i < x; ++i) {
					addZombie(input, sb);
				}
		
		sb.append("</level>");
		
		String xml = sb.toString();
		Writer w = null;
		try {
			w = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(f), "utf-8"), xml.length());
			w.write(xml);
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
	
	private static void addSkater(Scanner input, StringBuilder sb) {
		System.out.print("Enter the skater starting X coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int x = readInt(input, "(Example: 160)");
		System.out.print("Enter the skater starting Y coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int y = readInt(input, "(Example: 10)");
		sb.append("\t<skater x=\"" + x + "\" y=\"" + y + "\">\n");
		System.out.print("Enter skater start time in seconds: ");
		x = readInt(input, "(Example: 5)");
		sb.append("\t\t<start>" + x + "</start>\n");
		System.out.print("Enter skater time on ice in seconds: ");
		x = readInt(input, "(Example: 15)");
		sb.append("\t\t<time>" + x + "</time>\n");
		sb.append("\t</skater>\n");
	}
	
	private static void addPowerup(Scanner input, StringBuilder sb) {
		System.out.print("Enter the powerup starting X coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int x = readInt(input, "(Example: 160)");
		System.out.print("Enter the powerup starting Y coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int y = readInt(input, "(Example: 10)");
		sb.append("\t<powerup x=\"" + x + "\" y=\"" + y + "\">\n");
		String s = "";
		do {
			System.out.print("Enter powerup type (lawyer, hourglass, or bigz): ");
			s = input.next();
		} while (!s.equals("lawyer") && !s.equals("hourglass") && !s.equals("bigz"));
		sb.append("\t\t<type>" + s + "</type>\n");
		System.out.print("Enter powerup time on ice in seconds: ");
		x = readInt(input, "(Example: 15)");
		sb.append("\t\t<time>" + x + "</time>\n");
		sb.append("\t</powerup>\n");
	}
	
	private static void addZombie(Scanner input, StringBuilder sb) {
		System.out.print("Enter the zombie starting X coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int x = readInt(input, "(Example: 160)");
		System.out.print("Enter the zombie starting Y coordinate [assumes (" + frameWidth + ", " + frameHeight + ")]:");
		int y = readInt(input, "(Example: 10)");
		sb.append("\t<zombie x=\"" + x + "\" y=\"" + y + "\">\n");
		System.out.print("Enter zombie start time in seconds: ");
		x = readInt(input, "(Example: 5)");
		sb.append("\t\t<start>" + x + "</start>\n");
		sb.append("\t</zombie>\n");
	}
	
	private static int readInt(Scanner input, String exampleMsg) {
		while (input.hasNext()) {
			String s = input.next();
			try {
				return Integer.parseInt(s);
			} catch (NumberFormatException e) {
				System.out.println("Invalid input.");
				System.out.println("Please try again " + exampleMsg);
			}
		}
		return -1;
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
			if (!filename.endsWith(".xml"))
				filename += ".xml";
			return filename;
		}
		return null;
	}
}
