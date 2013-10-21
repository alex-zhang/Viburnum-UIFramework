package com.viburnum.components.baseClasses
{
	import com.viburnum.components.SkinableContainer;
	import com.viburnum.components.VerticalAlign;
	import com.viburnum.layouts.HorizontalLayout;

	public class TitleBarBase extends SkinableContainer
	{
		public function TitleBarBase()
		{
			tabChildren = false;

			var horizontalLayout:HorizontalLayout = new HorizontalLayout();
			horizontalLayout.verticalAlign = VerticalAlign.MIDDLE;
			horizontalLayout.paddingLeft = 4;
			horizontalLayout.paddingRight = 4;
			horizontalLayout.paddingTop = 4;
			horizontalLayout.paddingBottom = 4;
			
			contentLayout = horizontalLayout;
		}
	}
}