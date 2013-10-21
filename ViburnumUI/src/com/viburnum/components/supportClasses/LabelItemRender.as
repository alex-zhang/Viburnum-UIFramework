package com.viburnum.components.supportClasses
{
	import com.viburnum.components.ItemRender;
	import com.viburnum.components.Label;
	import com.viburnum.utils.LayoutUtil;

	[Style(name="labelStyleName", type="String")]
	
	public class LabelItemRender extends ItemRender
	{
		protected var lableTextField:Label;

		public function LabelItemRender()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			lableTextField = new Label();
			addChild(lableTextField);
		}

		override protected function labelChanged():void
		{
			lableTextField.text = label;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var measuredM:Number = LayoutUtil.getDisplayObjectMeasuredWidth(lableTextField);
			var measuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(lableTextField);
			
			setMeasuredSize(measuredM, measuredH);
			
			var measuredMinM:Number = LayoutUtil.getDisplayObjectMinWidth(lableTextField);
			var measuredMinH:Number = LayoutUtil.getDisplayObjectMinHeight(lableTextField);
			
			setMeasuredMinSize(measuredMinM, measuredMinH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			LayoutUtil.setDisplayObjectSize(lableTextField, layoutWidth, layoutHeight);
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "labelStyleName")
			{
				lableTextField.styleName = getStyle(styleProp);
			}
		}
	}
}