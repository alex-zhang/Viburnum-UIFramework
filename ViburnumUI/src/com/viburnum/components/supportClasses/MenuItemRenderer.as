package com.viburnum.components.supportClasses
{
	import com.viburnum.components.ItemRender;
	import com.viburnum.components.Label;
	import com.viburnum.components.MenuItemType;
	import com.viburnum.components.IMenuItemRenderer;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;

	[Style(name="checkIconSkin", type="Class", skinClass="true")]
	[Style(name="radioIconSkin", type="Class", skinClass="true")]
	[Style(name="separatorSkin", type="Class", skinClass="true")]
	[Style(name="branchIconSkin", type="Class", skinClass="true")]

	[Style(name="horizontalGap", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	
	include "../../style/styleMetadata/PaddingStyle.as";
	
	public class MenuItemRenderer extends ItemRender implements IMenuItemRenderer
	{
		public var checkIconSkin:DisplayObject;
		public var radioIconSkin:DisplayObject;
		public var separatorSkin:DisplayObject;
		public var branchIconSkin:DisplayObject;
		protected var lableTextField:Label;

		private var _type:String = MenuItemType.LABEL;//default
		private var _groupName:String = null;
		private var _hasBranch:Boolean = false;
		
		public function MenuItemRenderer()
		{
			super();
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get disabled():Boolean
		{
			return !this.enabled;
		}
		
		public function set disabled(value:Boolean):void
		{
			if(_type == MenuItemType.SEPARATOR)
			{
				this.enabled = false;
			}
			else
			{
				this.enabled = !value;	
			}
		}
		
		public function get toggled():Boolean
		{
			return this.selected;
		}
		
		public function set toggled(value:Boolean):void
		{
			this.selected = value;
		}
		
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void
		{
			_groupName = value;
		}
		
		public function get hasBranch():Boolean
		{
			return _hasBranch;
		}
		
		public function set hasBranch(value:Boolean):void
		{
			_hasBranch = value;
		}
		
		override public function set selected(value:Boolean):void
		{
			if(_type == MenuItemType.CHECK || _type == MenuItemType.RADIO)
			{
				super.selected = value;	
			}
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			lableTextField = new Label();
			addChild(lableTextField);

			lableTextField.setVisible((_type == MenuItemType.LABEL || _type == MenuItemType.RADIO || _type == MenuItemType.CHECK));
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.setDisplayObjectVisiable(separatorSkin, _type == MenuItemType.SEPARATOR);
			LayoutUtil.setDisplayObjectVisiable(checkIconSkin, _type == MenuItemType.CHECK);
			LayoutUtil.setDisplayObjectVisiable(radioIconSkin, _type == MenuItemType.RADIO);
			LayoutUtil.setDisplayObjectVisiable(branchIconSkin, _hasBranch);
		}
		
		override protected function dataChanged():void
		{
			super.dataChanged();
			
			if(_type == MenuItemType.RADIO)
			{
				LayoutUtil.setDisplayObjectVisiable(separatorSkin, false);
				LayoutUtil.setDisplayObjectVisiable(checkIconSkin, false);
				
				LayoutUtil.setDisplayObjectVisiable(radioIconSkin, true);
				LayoutUtil.setDisplayObjectVisiable(lableTextField, true);
			}
			else if(_type == MenuItemType.CHECK)
			{
				LayoutUtil.setDisplayObjectVisiable(separatorSkin, false);
				LayoutUtil.setDisplayObjectVisiable(radioIconSkin, false);

				LayoutUtil.setDisplayObjectVisiable(checkIconSkin, true);
				LayoutUtil.setDisplayObjectVisiable(lableTextField, true);
			}
			else if(_type == MenuItemType.SEPARATOR)
			{
				LayoutUtil.setDisplayObjectVisiable(separatorSkin, true);
				LayoutUtil.setDisplayObjectVisiable(radioIconSkin, false);
				
				LayoutUtil.setDisplayObjectVisiable(checkIconSkin, false);
				LayoutUtil.setDisplayObjectVisiable(lableTextField, false);
			}
			else//label default
			{
				LayoutUtil.setDisplayObjectVisiable(separatorSkin, false);
				LayoutUtil.setDisplayObjectVisiable(radioIconSkin, false);
				
				LayoutUtil.setDisplayObjectVisiable(checkIconSkin, false);
				LayoutUtil.setDisplayObjectVisiable(lableTextField, true);
			}
			
			LayoutUtil.setDisplayObjectVisiable(branchIconSkin, _hasBranch);
			
			lableTextField.text = this.label;
		}

		override protected function measure():void
		{
			super.measure();
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var hg:Number = getStyle("horizontalGap") || 0;
			
			var measuredMW:Number = 0;
			var measuredMH:Number = 0;
			
			if(!_type || _type == MenuItemType.LABEL || _type == MenuItemType.RADIO || _type == MenuItemType.CHECK)
			{
				var checkIconMeasuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(checkIconSkin);
				var checkIconMeasuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(checkIconSkin);

				var radioIconMeasuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(radioIconSkin);
				var radioIconMeasuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(radioIconSkin);
				
				var lableTextFieldMeauredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(lableTextField);
				var lableTextFieldMeauredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(lableTextField);
				
				var branchIconMeauredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(branchIconSkin);
				var branchIconMeauredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(branchIconSkin);
				
				measuredMW = Math.max(checkIconMeasuredW, radioIconMeasuredW) + hg + lableTextFieldMeauredW + branchIconMeauredW + hg;
				measuredMH = Math.max(lableTextFieldMeauredH, checkIconMeasuredH, radioIconMeasuredH, branchIconMeauredH);
			}
			else if(_type == MenuItemType.SEPARATOR)
			{
				measuredMW = LayoutUtil.getDisplayObjectMeasuredWidth(separatorSkin);
				measuredMH = LayoutUtil.getDisplayObjectMeasuredHeight(separatorSkin);
			}
			
			measuredMW += pl + pr;
			measuredMH += pt + pb;

			setMeasuredSize(measuredMW, measuredMH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			var hg:Number = getStyle("horizontalGap") || 0;
			
			var contenLayoutWidth:Number = layoutWidth - pl - pr;
			var contenLayoutHeight:Number = layoutHeight - pt - pb;
			var childX:Number = pl;
			
			if(!_type || _type == MenuItemType.LABEL || _type == MenuItemType.RADIO || _type == MenuItemType.CHECK)
			{
				var checkIconMeasuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(checkIconSkin);
				var checkIconMeasuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(checkIconSkin);
				
				var radioIconMeasuredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(radioIconSkin);
				var radioIconMeasuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(radioIconSkin);
				
				var lableTextFieldMeauredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(lableTextField);
				var lableTextFieldMeauredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(lableTextField);
				
				if(_type == MenuItemType.CHECK)
				{
					LayoutUtil.setDisplayObjectPosition(checkIconSkin, childX, pt + (contenLayoutHeight - checkIconMeasuredH) / 2);
					
					childX += checkIconMeasuredW + hg;
				}
				else if(_type == MenuItemType.RADIO)
				{
					LayoutUtil.setDisplayObjectPosition(radioIconSkin, childX, pt + (contenLayoutHeight - radioIconMeasuredH) / 2);
					
					childX += radioIconMeasuredW + hg;
				}
				else//defautl
				{
					childX += Math.max(checkIconMeasuredW, radioIconMeasuredW) + hg;
				}
				
				LayoutUtil.setDisplayObjectPosition(lableTextField, childX, pt + (contenLayoutHeight - lableTextFieldMeauredH) / 2);
				
				if(_hasBranch)
				{
					childX += lableTextFieldMeauredW + hg;
					
					var branchIconMeauredW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(branchIconSkin);
					var branchIconMeauredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(branchIconSkin);
					
					var hasChildrenChildX:Number = layoutWidth - branchIconMeauredW - pr;
					
					childX = Math.max(childX, hasChildrenChildX);
					
					LayoutUtil.setDisplayObjectPosition(branchIconSkin, 
						childX, pt + (contenLayoutHeight - branchIconMeauredH) * 0.5);
				}
			}
			else if(_type == MenuItemType.SEPARATOR)
			{
				var separatorSkinMeasuredH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(separatorSkin);
				
				LayoutUtil.setDisplayObjectLayout(separatorSkin, 
					childX, pt + (contenLayoutHeight - separatorSkinMeasuredH) * 0.5, 
					contenLayoutWidth, separatorSkinMeasuredH);
			}
		}
	}
}