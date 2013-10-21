package com.viburnum.skins
{
	import flash.display.Graphics;

	public class VRuleSkin extends ProgrammaticSkin
	{
		public function VRuleSkin()
		{
			super();
		}
		
		override public function get measuredWidth():Number
		{
			return getStyle("strokeWidth") || 2;
		}
		
		override public function get measuredHeight():Number
		{
			return 100;
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var g:Graphics = graphics;
			g.clear();
			
			// Look up the style properties
			var strokeColor:Number = getStyle("strokeColor");
			var shadowColor:Number = getStyle("shadowColor");
			var strokeWidth:Number = getStyle("strokeWidth") || 2;
			
			// The thickness of the stroke shouldn't be greater than
			// the layoutWidth of the bounding rectangle.
			if (strokeWidth > layoutWidth)
				strokeWidth = layoutWidth;
			
			// The vertical rule extends from the top edge
			// to the bottom edge of the bounding rectangle and
			// is horizontally centered within the bounding rectangle.
			var left:Number = (layoutWidth - strokeWidth) / 2;
			var top:Number = 0;
			var right:Number = left + strokeWidth;
			var bottom:Number = layoutHeight;
			
			if (strokeWidth == 1)
			{
				// *
				// *
				// *
				// *
				// *
				// *
				// *
				
				g.beginFill(strokeColor);
				g.drawRect(left, top, right-left, layoutHeight);
				g.endFill();
			}
			else if (strokeWidth == 2)
			{
				// *o
				// *o
				// *o
				// *o
				// *o
				// *o
				// *o
				
				g.beginFill(strokeColor);
				g.drawRect(left, top, 1, layoutHeight);
				g.endFill();
				
				g.beginFill(shadowColor);
				g.drawRect(right - 1, top, 1, layoutHeight);
				g.endFill();
			}
			else if (strokeWidth > 2)
			{
				// **o
				// * o
				// * o
				// * o
				// * o
				// * o
				// ooo
				
				g.beginFill(strokeColor);
				g.drawRect(left, top, right - left - 1, 1);
				g.endFill();
				
				g.beginFill(shadowColor);
				g.drawRect(right - 1, top, 1, layoutHeight - 1);
				g.drawRect(left, bottom - 1, right - left, 1);
				g.endFill();
				
				g.beginFill(strokeColor);
				g.drawRect(left, top + 1, 1, layoutHeight - 2);
				g.endFill();
			}
		}
	}
}