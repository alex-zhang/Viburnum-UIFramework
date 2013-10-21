package com.viburnum.components.baseClasses
{
	import com.viburnum.components.SkinableComponent;
	import com.viburnum.utils.EdgeMetrics;
	import com.viburnum.interfaces.IBorder;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	include "../../style/styleMetadata/BorderStyle.as";

	public class BorderComponentBase extends SkinableComponent implements IBorder
	{
		public static function getStyleDefinition():Object 
		{
			return [
				{name:"borderSkin", type:"Class", skinClass:"true"},
				
				{name:"borderSkin_borderStyle", type:"String", enumeration:"solid,none", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"borderSkin_borderVisible", type:"Boolean"},
				{name:"borderSkin_borderColor", type:"uint", format:"Color"},
				{name:"borderSkin_borderAlpha", type:"Number"},
				{name:"borderSkin_borderWeight", type:"Number", format:"Length", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"borderSkin_cornerRadius", type:"Number", format:"Length"},
				
				{name:"borderSkin_dropShadowVisible", type:"Boolean"},
				{name:"borderSkin_dropShadowAlpha", type:"Number", format:"Length"},
				{name:"borderSkin_dropShadowAngle", type:"Number", format:"Length"},
				{name:"borderSkin_dropShadowBlur", type:"Number", format:"Length"},
				{name:"borderSkin_dropShadowColor", type:"uint", format:"Color"},
				{name:"borderSkin_dropShadowDistance", type:"Number", format:"Length"},
				{name:"borderSkin_dropShadowStrength", type:"Number", format:"Length"},
				{name:"borderSkin_dropShadowInner", type:"Boolean"},
				
				{name:"borderSkin_backgroundColor", type:"uint", format:"Color"},
				{name:"borderSkin_backgroundAlpha", type:"Number"},
				{name:"borderSkin_backgroundImage", type:"Class"},
				{name:"borderSkin_backgroundImageFillMode", type:"String", enumeration:"scale,clip,repeat"},
			]
		}
		
		public var borderSkin:DisplayObject;

		public function BorderComponentBase()
		{
			super();
		}

		//Interface IBorder==================================
		public function get borderMetrics():EdgeMetrics
		{
			return borderSkin is IBorder ? 
				IBorder(borderSkin).borderMetrics : 
				EdgeMetrics.EMPTY;
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			LayoutUtil.setDisplayObjectSize(borderSkin, layoutWidth, layoutHeight);
		}
	}
}