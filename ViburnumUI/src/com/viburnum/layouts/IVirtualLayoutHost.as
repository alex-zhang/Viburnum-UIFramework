package com.viburnum.layouts
{
	import com.viburnum.interfaces.IViewport;
	
	import flash.display.DisplayObject;

	public interface IVirtualLayoutHost extends ILayoutHost
	{
		function getItemIndicesInView():Vector.<int>;
	}
}