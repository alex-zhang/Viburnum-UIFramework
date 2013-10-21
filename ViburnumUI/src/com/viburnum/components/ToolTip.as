package com.viburnum.components
{
	import com.viburnum.components.baseClasses.TextBase;
	
	import flash.display.DisplayObject;

	public class ToolTip extends TextBase implements IToolTip
	{
		public static var maxShowWidth:Number = 400;

		private var _toolTip:String;
		
		public function ToolTip()
		{
			super();
		}
		
		override public function get toolTip():String
		{
			return _toolTip;
		}

		override public function set toolTip(value:String):void
		{
			if(_toolTip != value)
			{
				_toolTip = value;

				text = _toolTip;
			}
		}
		
		override protected function measure():void
		{
			holdTextField.wordWrap = false;

			super.measure();

			if(measuredWidth > maxShowWidth)
			{
				var pl:Number = getStyle("paddingLeft") || 0;
				var pr:Number = getStyle("paddingRight") || 0;
				
				var bl:Number = borderMetrics.left;
				var br:Number = borderMetrics.right;

				holdTextField.wordWrap = true;
				DisplayObject(holdTextField).width = maxShowWidth - pl - pr - bl - br;
				
				super.measure();
			}
		}
	}
}