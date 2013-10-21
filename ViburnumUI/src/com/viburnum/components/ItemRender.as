package com.viburnum.components
{
	import com.viburnum.utils.LayoutUtil;
	import com.viburnum.utils.UpdateAfterEventGloabalControlUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	include "../style/styleMetadata/BackgroundStyle.as";
	include "../style/styleMetadata/StatedBackgroundStyle.as";
	include "../style/styleMetadata/ExtendedStatedBackgroundStyle.as";

	public class ItemRender extends SkinableComponent implements IItemRender
	{
		public static function getStyleDefinition():Object 
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
				
				//StatedBackgroundStyle
				{name:"backgroundSkin_upSkin", type:"Class"},
				{name:"backgroundSkin_overSkin", type:"Class"},
				{name:"backgroundSkin_downSkin", type:"Class"},
				{name:"backgroundSkin_disabledSkin", type:"Class"},
				
				{name:"backgroundSkin_upSkin", type:"Class"},
				{name:"backgroundSkin_overSkin", type:"Class"},
				{name:"backgroundSkin_downSkin", type:"Class"},
				{name:"backgroundSkin_disabledSkin", type:"Class"},
				
				//ExtendedStatedBackgroundStyle
				{name:"backgroundSkin_selected_upSkin", type:"Class"},
				{name:"backgroundSkin_selected_overSkin", type:"Class"},
				{name:"backgroundSkin_selected_downSkin", type:"Class"},
				{name:"backgroundSkin_selected_disabledSkin", type:"Class"},
			]
		}
		
		public var backgroundSkin:DisplayObject;

		private var _itemIndex:int = -1;

		private var _selected:Boolean = false;
		private var _selectedChangedFlag:Boolean = false;

		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		
		private var _data:Object;
		private var _dataChangedFlag:Boolean = true;
		
		private var _label:String = "";
		private var _labelChangedFlag:Boolean = false;
		
		public function ItemRender()
		{
			super();

			currentState = StateName.UP;
		}
		
		//IItemRenderer Interface==========================================
		public function get label():String
		{
			return _label;	
		}
		
		public function set label(value:String):void
		{
			if(_label != value)
			{
				_label = value;	
				
				_labelChangedFlag = true;
				invalidateProperties();
			}
		}
		
		//--
		
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				_selectedChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(_data != value)
			{
				_data = value;
				
				_dataChangedFlag = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_selectedChangedFlag)
			{
				_selectedChangedFlag = false;
				selectedChanged();
			}
			
			if(_labelChangedFlag)
			{
				_labelChangedFlag = false;
				labelChanged();
			}
			
			if(_dataChangedFlag)
			{
				_dataChangedFlag = false;
				dataChanged();
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			LayoutUtil.setDisplayObjectSize(backgroundSkin, layoutWidth, layoutHeight);
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.setDisplayObjectChildIndex(this, backgroundSkin, 0);
		}

		protected function labelChanged():void
		{
		}
		
		protected function dataChanged():void
		{
		}
		
		protected function selectedChanged():void
		{
			currentState = getCurrentSkinState();
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			if(!_isMouseDown) return;
			
			_isMouseDown = false;
			
			currentState = getCurrentSkinState();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);

			event.updateAfterEvent();
		}
		
		override protected function getCurrentSkinState():String//up over down disable
		{
			var skinState:String;
			
			if(!enabled)
			{
				skinState = StateName.DISABLED;
			}
			else if(_isMouseOver && _isMouseDown)
			{
				skinState = StateName.DOWN;
			}
			else if(_isMouseOver && !_isMouseDown || !_isMouseOver && _isMouseDown)
			{
				skinState = StateName.OVER;
			}
			else
			{
				skinState = StateName.UP;
			}
			
			if(_selected)
			{
				return "selected_" + skinState;
			}
			
			return skinState;
		}
		
		//event handler
		private function rollOverHandler(event:MouseEvent):void
		{
			if(event.buttonDown && !_isMouseDown) return;
			
			_isMouseOver = true;

			currentState = getCurrentSkinState();
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		private function rollOutHandler(event:MouseEvent):void
		{
			if(event.buttonDown && !_isMouseDown) return;
			
			_isMouseOver = false;
			
			currentState = getCurrentSkinState();

			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			_isMouseDown = true;
			
			currentState = getCurrentSkinState();

			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
			
			UpdateAfterEventGloabalControlUtil.requetsUpdateAfterEvent(event);
		}
	}
}