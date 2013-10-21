package com.viburnum.managers
{
	import com.viburnum.components.SkinableComponent;
	import com.viburnum.components.IButton;
	import com.viburnum.components.IFocusManagerComponent;
	import com.viburnum.components.IFocusManagerContainer;
	import com.viburnum.components.IUIComponent;
	import com.alex.utils.NameUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	//Stage 上可以同时存在多个FocusManager,但是激活的只有一个, FocusManager 之间关系是竞争的关系 
	public class FocusManager implements IFocusManager
	{
		private var _container:IFocusManagerContainer;
		
		private var _currentFocus:IFocusManagerComponent;
		
		private var _currentDefaultButton:IButton;
		private var _defaultButtonEnabled:Boolean = true;

		private var _focusPane:Sprite;

		private var _isActivated:Boolean = false;
		private var _lastAction:String;
		
		private var _showFocusIndicator:Boolean = true;
		
		private var _initialized:Boolean = false;

		private var _name:String;
		
		private var _focusableObjects:Array = []; 
		
		
		public function FocusManager(container:IFocusManagerContainer)
		{
			_name = NameUtil.createUniqueName(this);

			return;
			if(container != null)
			{
				_container = container;

				if(DisplayObject(_container).stage != null)
				{
					initializ();
				}
				else
				{
					_container.addEventListener(Event.ADDED_TO_STAGE, contanerAddToStageHandler);
					_container.addEventListener(Event.REMOVED_FROM_STAGE, contanerRemoveFromStageHandler);
				}
			}
		}
		
		private function initializ():void
		{
			if(!_initialized)
			{
				_initialized = true;

				activate();
			}
		}
		
		//IFocusManager Interface
		public function get defaultButton():IButton
		{
			return _container.defaultButton;
		}
		
		public function get defaultButtonEnabled():Boolean
		{
			return _defaultButtonEnabled;
		}
		
		public function set defaultButtonEnabled(value:Boolean):void
		{
			_defaultButtonEnabled = value;
			
			if(_currentDefaultButton != null)
			{
				_currentDefaultButton.emphasized = _defaultButtonEnabled;
			}
		}
		
		public function get focusPane():Sprite
		{
			return _focusPane;
		}
		
		public function set focusPane(value:Sprite):void
		{
			_focusPane = value;
		}
		
		public function get showFocusIndicator():Boolean
		{
			return _showFocusIndicator;
		}
		
		public function set showFocusIndicator(value:Boolean):void
		{
			_showFocusIndicator = value;
		}
		
		public function getFocus():IFocusManagerComponent
		{
			return _currentFocus;
		}
		
		public function setFocus(o:IFocusManagerComponent):void
		{
			if(!_initialized || !_isActivated) return;

			_currentFocus = o;

			if(stage != null)
			{
				stage.focus = InteractiveObject(o);
			}
		}

		public function showFocus():void
		{
			if(!_initialized || !_isActivated) return;
			
			if(!_showFocusIndicator)
			{
				_showFocusIndicator = true;
				
				if(getFocus() != null)
				{
					getFocus().drawFocus(true);
				}
			}
		}
		
		public function hideFocus():void
		{
			if(!_initialized || !_isActivated) return;
			
			if(_showFocusIndicator)
			{
				_showFocusIndicator = false;
				
				if(getFocus() != null)
				{
					getFocus().drawFocus(false);
				}
			}
		}

		public function activate():void
		{
			if(!_initialized) return;

			if(!_isActivated)
			{
				_isActivated = true;

//				if(_currentFocusManager != null)
//				{
//					_currentFocusManager.deactivate();
//				}

//				_currentFocusManager = this;

				stage.addEventListener(Event.ACTIVATE, stageActivateHandler, false, 0, true);
				stage.addEventListener(Event.DEACTIVATE, stageDeactivateHandler, false, 0, true);

//				stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, stageKeyFocusChangeHandler, false, 0, true);
//				_container.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
				
				_container.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, false, 0, true);
				_container.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, false, 0, true);
			}
		}
		
		public function registFocusManagerComponent(target:IFocusManagerComponent):void
		{
			if(target is IUIComponent && IUIComponent(target).focusManager != this) return; 
			
			var index:int = _focusableObjects.indexOf(target);
			if(index == -1)
			{
				_focusableObjects.push(target);
//				
//				var targetTabIndex:int =  target.tabIndex;
//				
//				var n:int = _focusableObjects.length;
//				for(var i:int = 0; i < n; i++)
//				{
//					var tabIndex:int =  IFocusManagerComponent(_focusableObjects[i]).tabIndex;
//					if(targetTabIndex > tabIndex)
//					{
//						
//					}
//				}
			}
			
			sortFocusableObjects();
		}
		
		private function sortFocusableObjects():void
		{
			_focusableObjects = _focusableObjects.sort(sortonTabIndex);
		}

		public function unRegistFocusManagerComponent(target:IFocusManagerComponent):void
		{
			if(target is IUIComponent && IUIComponent(target).focusManager != this) return; 
			
			var index:int = _focusableObjects.indexOf(target);
			if(index != -1)
			{
				_focusableObjects.splice(index, 1);
			}
		}

		private function sortonTabIndex(target0:IFocusManagerComponent, target1:IFocusManagerComponent):Number
		{
			var tabInxex0:int = target0.tabIndex;
			var tabInxex1:int = target0.tabIndex;
			
			if(tabInxex0 < tabInxex1)
			{
				return -1;
			}
			else if(tabInxex0 > tabInxex1)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		private function hasFocusableObjects():Boolean
		{
			return _focusableObjects.length != 0;
		}
		
		public function getNextFocusManagerComponent(backward:Boolean = false):IFocusManagerComponent
		{
			if(!_isActivated || !hasFocusableObjects()) return null;
			
			var target:IFocusManagerComponent = findNextFocusManagerComponent(_currentFocus);
			return target;
		}
		
		private function getFocusManagerComponentTabIndex(target:IFocusManagerComponent):int
		{
			var n:int = _focusableObjects.length;
			for(var i:int = 0; i < n; i++)
			{
				var o:IFocusManagerComponent = _focusableObjects[i];
				if(o == target)
				{
					return o.tabIndex;
				}
			}
			
			return -1;
		}

		private function findNextFocusManagerComponent(target:IFocusManagerComponent):IFocusManagerComponent
		{
			var n:int = _focusableObjects.length;
			if(n == 0) return null;

			var index:int = -1;

			if(target != null)
			{
				index = _focusableObjects.indexOf(target);
				if(index == -1) return null;	
			}

			index++;

			if(index == n) index = 0;

			return _focusableObjects[index] as IFocusManagerComponent;
		}

		private function contanerAddToStageHandler(event:Event):void
		{
			_container.removeEventListener(Event.ADDED_TO_STAGE, contanerAddToStageHandler);

			initializ();
		}

		private function contanerRemoveFromStageHandler(event:Event):void
		{
			_container.removeEventListener(Event.REMOVED_FROM_STAGE, contanerAddToStageHandler);

			deactivate();
		}

		public function deactivate():void
		{
			if(_isActivated)
			{
				_isActivated = false;

//				stage.removeEventListener(Event.ACTIVATE, stageActivateHandler);
//				stage.removeEventListener(Event.DEACTIVATE, stageDeactivateHandler);

				stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, stageKeyFocusChangeHandler, false);
				
				_container.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
				_container.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
				_container.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
			}
		}

		public function findFocusManagerComponent(o:InteractiveObject):IFocusManagerComponent
		{
			try
			{
				while(o != null)
				{
					if(o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled)
					{
						return o as IFocusManagerComponent;
					}
					
					o = o.parent;
				}
			}
			catch (error:Error)
			{
				// can happen in a loaded child swf
				// trace("findFocusManagerComponent: handling security error");
			}
			
			// tab was set somewhere else
			return null;
		}
		
		public function toString():String
		{
			return _name;
		}
		
		private function sendDefaultButtonEvent():void
		{
			if(defaultButtonEnabled && _currentDefaultButton != null)
			{
				var enabledBtn:Boolean = _currentDefaultButton is SkinableComponent ? 
					SkinableComponent(_currentDefaultButton).enabled : true; 

				if(enabledBtn)
				{
					if(_currentDefaultButton.hasEventListener(MouseEvent.CLICK))
					{
						_currentDefaultButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));	
					}
				}
			}
		}
		
		private function isInManager(o:DisplayObject):Boolean
		{
			if(o == null) return false;
			var inDisplayList:Boolean = DisplayObjectContainer(_container).contains(o);
			if(inDisplayList) return true;
			
			if(o is IUIComponent && IUIComponent(o).owner != null)
			{
				var ownOnDisplayList:Boolean = DisplayObjectContainer(_container).contains(IUIComponent(o).owner);
				if(ownOnDisplayList) return true;
			}
			
			return false;
		}
		
		private function getTopLevelFocusTarget(o:InteractiveObject):InteractiveObject
		{
			while(o != null && o != InteractiveObject(_container))
			{
				if(o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled && IFocusManagerComponent(o).mouseFocusEnabled) 
				{
					return o;
				}

				o = o.parent;
			}

			return null;
		}

		//eventHandler
		private function stageKeyFocusChangeHandler(event:FocusEvent):void
		{
			if(!_isActivated) return;
			
			showFocusIndicator = true;

			if((event.keyCode == Keyboard.TAB))
			{
				var nextFocusManagerComponent:IFocusManagerComponent = getNextFocusManagerComponent();
				setFocus(nextFocusManagerComponent);
			}
		}

		private function stageActivateHandler(event:Event):void
		{
			if(!_isActivated) return;
			
			var target:InteractiveObject = InteractiveObject(event.target);

			if(_currentFocus != null)
			{
				if(_currentFocus is IFocusManagerComponent) 
				{
					setFocus(_currentFocus);
				}
			}
		}
		
		private function stageDeactivateHandler(event:Event):void
		{
			if(!_isActivated) return;
			var target:InteractiveObject = InteractiveObject(event.target);
		}

		private function get stage():Stage
		{
			return DisplayObject(_container).stage;
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			if(!_isActivated) return;
			
			if(event.keyCode == Keyboard.ESCAPE)
			{
				if(_currentFocus != null)
				{
					setFocus(null);
				}
			}
		}

		private function focusInHandler(event:FocusEvent):void
		{
			if(!_isActivated) return;

			var target:InteractiveObject = InteractiveObject(event.target);
			
			if(!isInManager(target)) return;
			
			if(_defaultButtonEnabled && defaultButton != null && target == defaultButton)
			{
			}
		}

		private function focusOutHandler(event:FocusEvent):void
		{
			if(!_isActivated) return;
			
//			var target:InteractiveObject = InteractiveObject(event.target);
		}
	}
}