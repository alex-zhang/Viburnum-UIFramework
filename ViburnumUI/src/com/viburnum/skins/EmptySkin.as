package com.viburnum.skins
{
	//不可见仅仅为了响应鼠标事件
	public class EmptySkin extends ProgrammaticSkin
	{
		public function EmptySkin()
		{
			super();
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, layoutWidth, layoutHeight);
			graphics.endFill();
		}
	}
}