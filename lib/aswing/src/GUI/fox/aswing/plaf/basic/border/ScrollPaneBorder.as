﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import GUI.fox.aswing.ASColor;
import GUI.fox.aswing.border.Border;
import GUI.fox.aswing.border.LineBorder;
import GUI.fox.aswing.plaf.UIResource;
import GUI.fox.aswing.UIDefaults;
import GUI.fox.aswing.UIManager;
 
/**
 * @author iiley
 */
class GUI.fox.aswing.plaf.basic.border.ScrollPaneBorder extends LineBorder implements UIResource{	
	
	private static var instance:Border;
	
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Border{
		if(instance == null){
			var table:UIDefaults = UIManager.getLookAndFeelDefaults();
			var color:ASColor = table.getColor("ScrollPane.darkShadow");
			instance = new ScrollPaneBorder(color);
		}
		return instance;
	}
	
	public function ScrollPaneBorder(color:ASColor){
		super(null, color, 1);
	}

}
