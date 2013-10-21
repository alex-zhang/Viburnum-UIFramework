package com.viburnum.components.baseClasses
{
	import com.viburnum.components.SkinableComponent;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	[Style(name="strokeSkin", type="Class", skinClass="true")]
	[Style(name="strokeSkin_shadowColor", type="uint", format="Color", invalidateDisplayList="true")]
	[Style(name="strokeSkin_strokeColor", type="uint", format="Color", invalidateDisplayList="true")]
	[Style(name="strokeSkin_strokeWidth", type="Number", format="Length", invalidateSize="true", invalidateDisplayList="true")]

	public class RuleBase extends SkinableComponent
	{
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"strokeSkin", type:"Class", skinClass:"true"},
				{name:"strokeSkin_shadowColor", type:"uint", format:"Color", invalidateDisplayList:"true"},
				{name:"strokeSkin_strokeColor", type:"uint", format:"Color", invalidateDisplayList:"true"},
				{name:"strokeSkin_strokeWidth", type:"Number", format:"Length", invalidateSize:"true", invalidateDisplayList:"true"},
			]
		}
		
		public var strokeSkin:DisplayObject;
		
		public function RuleBase()
		{
			super();
		}

		override protected function measure():void
		{
			var measuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(strokeSkin);
			var measuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(strokeSkin);

			setMeasuredSize(measuredW, measuredH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			LayoutUtil.setDisplayObjectSize(strokeSkin, layoutWidth, layoutHeight);
		}
	}
}