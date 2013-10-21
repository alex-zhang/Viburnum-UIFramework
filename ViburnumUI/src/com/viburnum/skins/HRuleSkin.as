package com.viburnum.skins
{
	
	import flash.display.Graphics;
	
	public class HRuleSkin extends ProgrammaticSkin
	{
		public function HRuleSkin()
		{
			super();
		}
		
		override public function get measuredWidth():Number
		{
			return 100;
		}
		
		override public function get measuredHeight():Number
		{
			return getStyle("strokeWidth") || 2;
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
			// the layoutHeight of the bounding rectangle.
			if (strokeWidth > layoutHeight)
				strokeWidth = layoutHeight;
			
			// The horizontal rule extends from the left edge
			// to the right edge of the bounding rectangle and
			// is vertically centered within the bounding rectangle.
			var left:Number = 0;
			var top:Number = (layoutHeight - strokeWidth) / 2;
			var right:Number = layoutWidth;
			var bottom:Number = top + strokeWidth;
			
			if (strokeWidth == 1)
			{
				// **************
				
				g.beginFill(strokeColor);
				g.drawRect(left, top, layoutWidth, bottom - top);
				g.endFill();
			}
			else if (strokeWidth == 2)
			{
				// **************
				// oooooooooooooo
				
				g.beginFill(strokeColor);
				g.drawRect(left, top, layoutWidth, 1);
				g.endFill();
				
				g.beginFill(shadowColor);
				g.drawRect(left, bottom - 1, layoutWidth, 1);
				g.endFill();
			}
			else if (strokeWidth > 2)
			{
				// *************o
				// *            o
				// oooooooooooooo
				
				g.beginFill(strokeColor);
				g.drawRect(left, top, layoutWidth - 1, 1);
				g.endFill();
				
				g.beginFill(shadowColor);
				g.drawRect(right - 1, top, 1, bottom - top - 1);
				g.drawRect(left, bottom - 1, layoutWidth, 1);
				g.endFill();
				
				g.beginFill(strokeColor);
				g.drawRect(left, top + 1, 1, bottom - top - 2);
				g.endFill();
			}
		}
	}
}