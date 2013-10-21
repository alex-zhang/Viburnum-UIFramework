package com.viburnum.components
{
	import com.viburnum.components.baseClasses.RealLayoutGroupBase;
	import com.viburnum.layouts.AbsoluteLayout;

	/**
	 * @author cheng
	 * 
	 */	
    public class Group extends RealLayoutGroupBase
    {
        public function Group()
        {
            super();

            layout = new AbsoluteLayout();
        }
    }
}