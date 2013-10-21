package com.viburnum.components.baseClasses
{
	import com.viburnum.interfaces.IBorder;
	import com.viburnum.utils.EdgeMetrics;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	include "../../style/styleMetadata/BackgroundStyle.as";
	include "../../style/styleMetadata/BorderStyle.as";
	include "../../style/styleMetadata/PaddingStyle.as";
	
	public class SkinnableContainerBase extends ContainerBase
	{
		public static function getStyleDefinition():Array 
		{
			return [
				//BackgroundStyle
				{name:"backgroundSkin", type:"Class", skinClass:"true"},
				{name:"backgroundSkin_backgroundAlpha", type:"Number"},
				{name:"backgroundSkin_backgroundColor", type:"uint", format:"Color"},
				{name:"backgroundSkin_backgroundImage", type:"Class"},
				{name:"backgroundSkin_backgroundImageFillMode", type:"String", enumeration:"scale,clip,repeat"},
				{name:"backgroundSkin_dropShadowVisible", type:"Boolean"},
				{name:"backgroundSkin_dropShadowAlpha", type:"Number", format:"Length"},
				{name:"backgroundSkin_dropShadowAngle", type:"Number", format:"Length"},
				{name:"backgroundSkin_dropShadowBlur", type:"Number", format:"Length"},
				{name:"backgroundSkin_dropShadowColor", type:"uint", format:"Color"},
				{name:"backgroundSkin_dropShadowDistance", type:"Number", format:"Length"},
				{name:"backgroundSkin_dropShadowStrength", type:"Number", format:"Length"},
				{name:"backgroundSkin_dropShadowInner", type:"Boolean"},
				
				//BorderStyle
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

				//PaddingStyle
				{name:"paddingLeft", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingRight", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingTop", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingBottom", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
			]
		}
		
		public var backgroundSkin:DisplayObject;
		public var borderSkin:DisplayObject;
		
		public function SkinnableContainerBase()
		{
			super();
		}
		
		public function get borderMetrics():EdgeMetrics
		{
			return borderSkin is IBorder ? 
				IBorder(borderSkin).borderMetrics : 
				EdgeMetrics.EMPTY;
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.sortDisplayObjectChildren(this, backgroundSkin, borderSkin);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var measuredMW:Number = 0;
			var measuredMH:Number = 0;
			var measuredMinW:Number = 0;
			var measuredMinH:Number = 0;
			
			//--
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var borderSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(borderSkin);
			var borderSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(borderSkin);
			
			var backgroundSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(backgroundSkin);
			var backgroundSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(backgroundSkin);
			
			var contentGroupMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(myContentGroup);
			var contentGroupMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(myContentGroup);
			
			//-
			
			measuredMW = Math.max(borderSkinMW, Math.max(backgroundSkinMW, contentGroupMW));
			measuredMH = Math.max(borderSkinMH, Math.max(backgroundSkinMH, contentGroupMH));
			
			setMeasuredSize(measuredMW, measuredMH);
			
			//--
			
			var contentGroupMinW:Number = LayoutUtil.getDisplayObjectMinWidth(myContentGroup);
			var contentGroupMinH:Number = LayoutUtil.getDisplayObjectMinHeight(myContentGroup);
			
			var borderSkinMinW:Number = LayoutUtil.getDisplayObjectMinWidth(borderSkin);
			var borderSkinMinH:Number = LayoutUtil.getDisplayObjectMinHeight(borderSkin); 
			
			measuredMinW = Math.max(contentGroupMinW, borderSkinMinW);
			measuredMinH = Math.max(contentGroupMinH, borderSkinMinH);
			
			setMeasuredMinSize(measuredMinW, measuredMinH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var left:Number = pl + bl;
			var top:Number = pt + bt;
			var right:Number = pr + br;
			var bottom:Number = pb + bb;
			
			var contenWidth:Number = layoutWidth - left - right;
			var contenHeight:Number = layoutHeight - top - bottom;
			
			LayoutUtil.layoutTargetAroundByScale9Grid2BorderMetrics(borderSkin, layoutWidth, layoutHeight);
			
			//background the same as contentGroup
			LayoutUtil.setDisplayObjectLayout(backgroundSkin, 
				left, top, contenWidth, contenHeight);
			
			LayoutUtil.setDisplayObjectLayout(myContentGroup, 
				left, top, contenWidth, contenHeight);
		}
	}
}