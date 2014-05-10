import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import javax.swing.AbstractButton;
import javax.swing.ButtonGroup;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.JToggleButton;


@SuppressWarnings("serial")
class TileOptions extends JFrame {
	private static final int BUTTON_WIDTH = 5;
	LevelEditor le;
	ButtonGroup group;
	public int cursorWidth = 1;
	public int cursorHeight = 1;
	private int x, y;
	
	public TileOptions(ImageIcon[] icons, final LevelEditor le) {
		this.le = le;
		this.setLayout(new BorderLayout());
		JPanel cursorOpts = new JPanel();
		JPanel buttonPanel = new JPanel();
		buttonPanel.setLayout(new GridLayout(Main.IMG_TILE_HEIGHT, Main.IMG_TILE_WIDTH));
		JScrollPane scroller = new JScrollPane(buttonPanel, 
				JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, 
				JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
		this.add(cursorOpts, BorderLayout.NORTH);
		this.add(scroller, BorderLayout.CENTER);
		final JTextField cursorHeightf = new JTextField("1  ");
		final JTextField cursorWidthf = new JTextField("1  ");
		cursorOpts.add(new JLabel("Cursor options: width, height"));
		cursorOpts.add(cursorWidthf);
		cursorOpts.add(cursorHeightf);
		JButton setOpts = new JButton("Set");
		setOpts.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent arg0) {
				try{
					cursorWidth = Integer.parseInt(cursorWidthf.getText().trim());
					cursorHeight = Integer.parseInt(cursorHeightf.getText().trim());
				}catch(Exception e){
					System.out.println("Warning: cannot set cursor width or height");
				}
					
			}
		});
		cursorOpts.add(setOpts);
		//buttonPanel.setLayout(new GridLayout(buttonHeight, BUTTON_WIDTH));
		buttonPanel.setBackground(Color.BLACK);
		group = new ButtonGroup();
		ActionListener buttListener = new ButtonHandler();
		for (int i = 0, len = icons.length; i < len; ++i) {
			JToggleButton b = new TileButton(icons[i], false, i, icons[i].getImage());
			b.setPreferredSize(new Dimension(Main.TILE_SIZE, Main.TILE_SIZE));
			group.add(b);
			b.addActionListener(buttListener);
			buttonPanel.add(b);
		}
		this.pack();
	}
	
	private List<TileButton> selectedButts = new ArrayList<TileButton>();
	private List<TileButton> getSelectedButts(){
		selectedButts.clear();
		Enumeration<AbstractButton> butts = group.getElements();
		TileButton b = (TileButton) butts.nextElement();
		for(;butts.hasMoreElements();b = (TileButton) butts.nextElement()){
			if(b.getX() >= x && b.getX() < x+cursorWidth*Main.TILE_SIZE)
				if(b.getY() >= y && b.getY() < y+cursorHeight*Main.TILE_SIZE)
					selectedButts.add(b);
		}
		return selectedButts;
	}
	
	class TileButton extends JToggleButton {
		int index;
		Image img;
		boolean isSelected = false;
		
		public TileButton(Icon icon, boolean selected, int index, Image img) {
			super(icon, selected);
			this.index = index;
			this.img = img;
		}
		
		@Override
		public void paint(Graphics g){
			g.drawImage(img, 0, 0, this.getWidth(), this.getHeight(), null);
			if(isSelected){
				g.setColor(Color.yellow);
				g.drawRect(0, 0, getWidth()-2, getHeight()-2);
			}
		}
	}
	
	private class ButtonHandler implements ActionListener{

		@Override
		public void actionPerformed(ActionEvent arg0) {
			TileButton src = ((TileButton)arg0.getSource());
			x = src.getX();
			y = src.getY();
			Enumeration<AbstractButton> butts = group.getElements();
			TileButton b = (TileButton) butts.nextElement();
			List<Range> rList = new ArrayList<Range>();
			List<Integer> iList = new ArrayList<Integer>(cursorWidth*cursorHeight);	//list of all indices of selected elements
			le.setButtonImageRange(new RangeList(Arrays.asList(new Range(src.index, src.index+3))));
			for(;butts.hasMoreElements();b = (TileButton) butts.nextElement()){
				if(b.getX() >= x && b.getX() < x+cursorWidth*Main.TILE_SIZE){
					if(b.getY() >= y && b.getY() < y+cursorHeight*Main.TILE_SIZE){
						b.isSelected = true;
						iList.add(b.index);
					}else{
						b.isSelected = false;
					}
				}else {
					b.isSelected = false;
				}
			}
			Collections.sort(iList);
			int start = iList.get(0), prev = iList.get(0);
			for(Integer i : iList){
				if(i > prev+1){
					rList.add(new Range(start, prev+1));
					start = i;
				}
				prev = i;
			}
			rList.add(new Range(start, prev+1));
			le.setButtonImageRange(new RangeList(rList));
			System.out.println("Returning range: "+new RangeList(rList));
			repaint();
		}
		
	}
}