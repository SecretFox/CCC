﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import GUI.fox.aswing.Component;
import GUI.fox.aswing.Container;
import GUI.fox.aswing.geom.Dimension;
import GUI.fox.aswing.LayoutManager;

/**
 * LayoutManager's empty implementation.
 * @author iiley
 */
class GUI.fox.aswing.EmptyLayout implements LayoutManager{
	
	public function EmptyLayout(){
	}
	
    /**
     * do nothing
     */
    public function addLayoutComponent(comp:Component, constraints:Object):Void{
    }

    /**
     * do nothing
     */
    public function removeLayoutComponent(comp:Component):Void{
    }
	
	/**
	 * return target.getSize();
	 */
    public function preferredLayoutSize(target:Container):Dimension{
    	return target.getSize();
    }

	/**
	 * new Dimension(0, 0);
	 */
    public function minimumLayoutSize(target:Container):Dimension{
    	return new Dimension(0, 0);
    }
	
	/**
	 * return new Dimension(Number.MAX_VALUE, Number.MAX_VALUE);
	 */
    public function maximumLayoutSize(target:Container):Dimension{
    	return new Dimension(Number.MAX_VALUE, Number.MAX_VALUE);
    }
    
    /**
     * do nothing
     */
    public function layoutContainer(target:Container):Void{
    }
    
	/**
	 * return 0
	 */
    public function getLayoutAlignmentX(target:Container):Number{
    	return 0;
    }

	/**
	 * return 0
	 */
    public function getLayoutAlignmentY(target:Container):Number{
    	return 0;
    }

    /**
     * do nothing
     */
    public function invalidateLayout(target:Container):Void{
    }		
}
