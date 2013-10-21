package com.viburnum.components
{
	import com.viburnum.events.CloseEvent;

	[Style(name="buttonStyleName", type="String")]
	[Style(name="messageStyleName", type="String")]

	public class Alert extends Panel
	{
		public static function getStyleDefinition():Array 
		{
			return [
				{name:"buttonStyleName", type:"String"},
				{name:"messageStyleName", type:"String"},
			]
		}
		
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint= 0x0008;
		public static const NONMODAL:uint = 0x8000;
		
		public static function show(application:IApplication,
									text:String = "", title:String = "",
									flags:uint = 0x4 /* Alert.OK */, 
									closeHandler:Function = null, 
									messageIconClass:Class = null, 
									defaultButtonFlag:uint = 0x4 /* Alert.OK */):Alert
		{
			if(!application) 
			{
				throw new Error("Alert::show application is null");	
			}
			
			var modal:Boolean = (flags & Alert.NONMODAL) ? false : true;
			
			var alert:Alert = new Alert();
			
			if (flags & Alert.OK||
				flags & Alert.CANCEL ||
				flags & Alert.YES ||
				flags & Alert.NO)
			{
				alert.buttonFlags = flags;
			}
			
			if (defaultButtonFlag == Alert.OK ||
				defaultButtonFlag == Alert.CANCEL ||
				defaultButtonFlag == Alert.YES ||
				defaultButtonFlag == Alert.NO)
			{
				alert.defaultButtonFlag = defaultButtonFlag;
			}
			
			alert.message = text;
			alert.title = title;
			alert.messageIconClass = messageIconClass;

			if(closeHandler != null)
			{
				alert.addEventListener(CloseEvent.CLOSE, closeHandler);
			}

			if(application.popupManager != null)
			{
				application.popupManager.addPopUp(alert, modal);
				application.popupManager.centerPopUp(alert, false);
			}
			
			return alert;
		}

		//======================================================================
		
		public var buttonFlags:uint = OK;
		public var defaultButtonFlag:uint = OK;
		public var messageIconClass:Class;
		public var message:String = "";
		
		private var _cancelLabel:String;
		private var _noLabel:String;
		private var _okLabel:String;
		private var _yesLabel:String;
		
		private var _alertForm:AlertForm;
		
		public function Alert()
		{
			super();
		}
		
		public function get cancelLabel():String
		{
			return _cancelLabel != null ?
				_cancelLabel :
				langManager.getString("Alert", "cancelLabel");
		}
		
		public function set cancelLabel(value:String):void
		{
			_cancelLabel = value;
		}
		
		public function get noLabel():String
		{
			return _noLabel != null ?
				_noLabel :
				langManager.getString("Alert", "noLabel");
		}
		
		public function set noLabel(value:String):void
		{
			_noLabel = value;
		}
		
		public function get okLabel():String
		{
			return _okLabel != null ?
				_okLabel :
				langManager.getString("Alert", "okLabel");
		}
		
		public function set okLabel(value:String):void
		{
			_okLabel = value;
		}

		public function get yesLabel():String
		{
			return yesLabel != null ?
				yesLabel :
				langManager.getString("Alert", "yesLabel");
		}
		
		public function set yesLabel(value:String):void
		{
			_yesLabel = value;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			createAlertForm();
		}
		
		protected function createAlertForm():void
		{
			_alertForm = new AlertForm();
			_alertForm.owner = this;
			_alertForm.percentWidth = 1;
			_alertForm.percentHeight = 1;
			addContentChild(_alertForm);
		}
	}
}

	import com.viburnum.components.Alert;
	import com.viburnum.components.Button;
	import com.viburnum.components.HGroup;
	import com.viburnum.components.HorizontalAlign;
	import com.viburnum.components.Label;
	import com.viburnum.components.VGroup;
	import com.viburnum.events.CloseEvent;
	import com.viburnum.layouts.HorizontalLayout;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	class AlertForm extends VGroup
	{
		private static const ALERT_BUTTON_PRE:String = "alertButtonNamePre_";
		
		private var _message:String;
		private var _messageChangedFlag:Boolean = false;
		
		private var _messageLabel:Label;
		private var _iconDisplayObject:DisplayObject;
		
		private var _topHGroup:HGroup;
		private var _buttonsHGroup:HGroup;

		private var _defaultButton:Button;
		
		public function AlertForm()
		{
			super();

			var layoutTarget:VerticalLayout = layout as VerticalLayout;
			layoutTarget.paddingLeft = 6;
			layoutTarget.paddingRight = 6;
			layoutTarget.paddingTop = 6;
			layoutTarget.paddingBottom = 6;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			if(alert == null) return;
			
			_topHGroup = new HGroup();
			_topHGroup.percentWidth = 1;
			_topHGroup.percentHeight = 1;
			addChild(_topHGroup);
			
			var iconCls:Class = alert.messageIconClass;
			if(iconCls != null)
			{
				_iconDisplayObject = new iconCls();
				
				if(_iconDisplayObject != null)
				{
					_topHGroup.addChild(_iconDisplayObject);
				}
			}
			
			_messageLabel = new Label();
			_messageLabel.selectable = true;
			_messageLabel.percentWidth = 1;
			_messageLabel.percentHeight = 1;
			_messageLabel.text = alert.message;
			_topHGroup.addChild(_messageLabel);
//			_topHGroup.viburnum_internal::isDebugDraw = true;
			
			_buttonsHGroup = new HGroup();
//			_buttonsHGroup.viburnum_internal::isDebugDraw = true;
			_buttonsHGroup.percentWidth = 1;
			HorizontalLayout(_buttonsHGroup.layout).horizontalAlign = HorizontalAlign.CENTER;
			addChild(_buttonsHGroup);
			
			var buttonFlags:uint = alert.buttonFlags;
			var defaultButtonFlag:uint = alert.defaultButtonFlag;
			
			var label:String;
			var button:Button;

			if(buttonFlags & Alert.OK)
			{
				label = alert.okLabel;
				button = createButton(label, Alert.OK);
				if (defaultButtonFlag == Alert.OK)
				{
					_defaultButton = button;
				}
			}
			
			if(buttonFlags & Alert.YES)
			{
				label = alert.yesLabel;
				button = createButton(label, Alert.YES);
				if (defaultButtonFlag == Alert.YES)
				{
					_defaultButton = button;
				}
			}
			
			if(buttonFlags & Alert.NO)
			{
				label = alert.noLabel;
				button = createButton(label, Alert.NO);
				if (defaultButtonFlag == Alert.NO)
				{
					_defaultButton = button;
				}
			}
			
			if(buttonFlags & Alert.CANCEL)
			{
				label = alert.cancelLabel;
				button = createButton(label, Alert.CANCEL);
				if (defaultButtonFlag == Alert.CANCEL)
				{
					_defaultButton = button;
				}
			}
			
			if(!_defaultButton && _buttonsHGroup.numChildren)
			{
				_defaultButton = _buttonsHGroup.getChildAt(0) as Button;
			}
		}
		
		private function createButton(label:String, buttonFlag:uint):Button
		{
			var button:Button = new Button();
			button.label = label;
			button.name = ALERT_BUTTON_PRE + buttonFlag.toString();
			button.styleName = alert.getStyle("buttonStyleName");
			button.addEventListener(MouseEvent.CLICK, alertButtonClickHandler);
			button.addEventListener(KeyboardEvent.KEY_UP, alertButtonKeyUpHandler);
			
			_buttonsHGroup.addChild(button);
			
			return button;
		}
		
		private function removeAlert(buttonFlag:uint):void
		{
			if(hasEventListener(CloseEvent.CLOSE))
			{
				var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
				closeEvent.detail = buttonFlag;
				alert.dispatchEvent(closeEvent);
			}

			if(popupManager != null)
			{
				popupManager.removePopUp(alert);	
			}
		}
		
		private function get alert():Alert
		{
			return owner as Alert;
		}
		
		private function alertButtonClickHandler(event:MouseEvent):void
		{
			var name:String = Button(event.currentTarget).name;
			var subStrName:String = name.substr(ALERT_BUTTON_PRE.length);
			var buttonFlag:uint = parseInt(subStrName);
			
			removeAlert(buttonFlag);
		}

		private function alertButtonKeyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
			{
				var buttonFlags:uint = alert.buttonFlags;
				
				if((buttonFlags & Alert.CANCEL) || !(buttonFlags & Alert.NO))
				{
					removeAlert(Alert.CANCEL);
				}
				else if (buttonFlags & Alert.NO)
				{
					removeAlert(Alert.NO);
				}
			}
		}
	}