package com.viburnum.components.supportClasses
{
	import com.viburnum.components.StateName;
	import com.viburnum.components.baseClasses.TextBase;
	import com.viburnum.components.baseClasses.TitleBarBase;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	[Style(name="backgroundSkin_upSkin", type="Class")]
	[Style(name="backgroundSkin_overSkin", type="Class")]
	[Style(name="backgroundSkin_downSkin", type="Class")]
	[Style(name="backgroundSkin_disabledSkin", type="Class")]
	
	[Style(name="backgroundSkin_selected_upSkin", type="Class")]
	[Style(name="backgroundSkin_selected_overSkin", type="Class")]
	[Style(name="backgroundSkin_selected_downSkin", type="Class")]
	[Style(name="backgroundSkin_selected_disabledSkin", type="Class")]
	
	public class AccordionTitleBar extends TitleBarBase
	{
		private var _selected:Boolean = false;
		private var _selectedChangedFlag:Boolean = false;
		
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		
		private var _iconInstance:DisplayObject;
		private var _label:TextBase;

		public function AccordionTitleBar()
		{
			super();
			
			currentState = StateName.UP;
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
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
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			if(event.buttonDown && !_isMouseDown) return;
			
			_isMouseOver = true;
			
			currentState = getCurrentSkinState();
			
			event.updateAfterEvent();
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			if(event.buttonDown && !_isMouseDown) return;
			
			_isMouseOver = false;
			
			currentState = getCurrentSkinState();
			
			event.updateAfterEvent();
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			_isMouseDown = true;
			currentState = getCurrentSkinState();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
			
			event.updateAfterEvent();
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			if(!_isMouseDown) return;
			
			_isMouseDown = false;
			
			currentState = getCurrentSkinState();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			
			event.updateAfterEvent();
		}
	}
}