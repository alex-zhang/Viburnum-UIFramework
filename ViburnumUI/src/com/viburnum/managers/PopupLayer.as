package com.viburnum.managers
{
	import com.viburnum.components.IApplication;
	import com.viburnum.core.LayoutSpriteElement;
	import com.viburnum.core.viburnum_internal;
	import com.viburnum.events.ViburnumMouseEvent;
	import com.viburnum.layouts.PositionConstrainType;
	import com.viburnum.style.CSSStyleDeclaration;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	use namespace viburnum_internal;

	public class PopupLayer extends LayoutSpriteElement
	{
		private static const MAX_CACHED_MODAL_SKIN_COUNT:uint = 5;
		
		public var application:IApplication;
		
		private var _popupChildInfos:Array = [];//PopupChildInfo
		private var _modalWindowCount:int = 0;
		private var _hasListenApplicationMouseDownFlag:Boolean = false;
		
		private var _cachedModalSkins:Array = [];

		public function PopupLayer()
		{
			super();
			
			explicitCanSkipMeasure = true;
		}

		public function addPopUp(window:DisplayObject, modal:Boolean = false, modalAlpha:Number = NaN):void
		{
			var index:int = getWindowPopupChildInfosIndex(window);
			if(index != -1) return;

			var relatedModalSkin:DisplayObject = null;
			if(modal)
			{
				if(_modalWindowCount == 0)
				{
					application.lockContentInteraction();
				}
				
				_modalWindowCount++;

				var relatedModalSkinCls:Class = getGlobalStyle("modalSkin");
				var actualModalAlpha:Number = isNaN(modalAlpha) ? getGlobalStyle("modalAlpha") || 1 : modalAlpha;

				if(relatedModalSkinCls != null)
				{
					if(_cachedModalSkins.length > 0)//缓存relatedModalSkin
					{
						relatedModalSkin = _cachedModalSkins.pop();
					}
					else
					{
						relatedModalSkin = new relatedModalSkinCls();
					}
				}
				
				if(relatedModalSkin != null)
				{
					relatedModalSkin.alpha = actualModalAlpha;
					addChild(relatedModalSkin);
				}
			}

			addChild(window);
			
			var popupChildInfo:PopupChildInfo = new PopupChildInfo(window, relatedModalSkin, modal);
			_popupChildInfos.push(popupChildInfo);
			
			if(!_hasListenApplicationMouseDownFlag)
			{
				_hasListenApplicationMouseDownFlag = true;
				
				application.addEventListener(MouseEvent.MOUSE_DOWN, applicationMouseDownHandler,false , int.MAX_VALUE);
			}

			invalidateDisplayList();
		}
		
		public function bringToFront(window:DisplayObject):void
		{
			var index:int = getWindowPopupChildInfosIndex(window);
			if(index == -1 || numChildren == 0) return;
			
			var popupChildInfo:PopupChildInfo = _popupChildInfos[index];
			if(popupChildInfo.isModalMode)
			{
				var relatedModalSkin:DisplayObject = popupChildInfo.relatedModalSkin;
				var targetWindow:DisplayObject = popupChildInfo.window;

				if(relatedModalSkin != null)
				{
					setChildIndex(relatedModalSkin, numChildren - 1);
				}

				setChildIndex(targetWindow, numChildren - 1);
			}
		}
		
		public function bringToBack(window:DisplayObject):void
		{
			var index:int = getWindowPopupChildInfosIndex(window);
			if(index == -1 || numChildren == 0) return;
			
			var popupChildInfo:PopupChildInfo = _popupChildInfos[index];
			if(popupChildInfo.isModalMode)
			{
				var relatedModalSkin:DisplayObject = popupChildInfo.relatedModalSkin;
				var targetWindow:DisplayObject = popupChildInfo.window;
				
				setChildIndex(targetWindow, 0);
				
				if(relatedModalSkin != null)
				{
					setChildIndex(relatedModalSkin, 0);
				}
			}
		}

		public function constrainPostion(window:DisplayObject, constrainType:String = PositionConstrainType.CUSTOM, 
										 isAlwaysConstrain:Boolean = false):void
		{
			var index:int = getWindowPopupChildInfosIndex(window);
			if(index == -1) return;
			
			var popupChildInfo:PopupChildInfo = _popupChildInfos[index];
			popupChildInfo.constrainType = constrainType;
			popupChildInfo.isAlwaysConstrain = isAlwaysConstrain;

			invalidateDisplayList();
		}

		public function removePopUp(window:DisplayObject):void
		{
			var index:int = getWindowPopupChildInfosIndex(window);
			if(index == -1) return;

			var popupChildInfo:PopupChildInfo = _popupChildInfos[index];
			if(popupChildInfo.isModalMode)
			{
				_modalWindowCount--;
				
				if(_modalWindowCount == 0)
				{
					application.unLockContentInteraction();
				}
				
				var relatedModalSkin:DisplayObject = popupChildInfo.relatedModalSkin; 
				if(relatedModalSkin != null)
				{
					removeChild(relatedModalSkin);
					
					if(_cachedModalSkins.length < MAX_CACHED_MODAL_SKIN_COUNT)
					{
						_cachedModalSkins.push(relatedModalSkin);
					}
				}
			}

			removeChild(window);
			
			_popupChildInfos.splice(index, 1);
			
			if(_hasListenApplicationMouseDownFlag && _popupChildInfos.length == 0)
			{
				_hasListenApplicationMouseDownFlag = false;
				
				application.removeEventListener(MouseEvent.MOUSE_DOWN, applicationMouseDownHandler, true);
			}
		}
		
		viburnum_internal function removeAllPopUpChildren():void
		{
			while(_popupChildInfos.length > 0)
			{
				var childInfo:PopupChildInfo = _popupChildInfos[0];
				
				removePopUp(childInfo.window);
			}
		}

		public function getAllPopUpWindow():Array//DisplayObejct
		{
			var windows:Array  = [];
			var n:uint = _popupChildInfos.length;
			for(var i:uint = 0; i < n; i++)
			{
				var popupChildInfo:PopupChildInfo = _popupChildInfos[i];
				var window:DisplayObject = popupChildInfo.window;
				windows.push(window);
			}

			return windows;
		}
		
		public function getModalWindowCount():int
		{
			return _modalWindowCount;
		}
		
		public function hasWindow(window:DisplayObject):Boolean
		{
			if(window == null) return false;
			return getWindowPopupChildInfosIndex(window) != -1;
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			var n:uint = _popupChildInfos.length;
			
			for(var i:uint = 0; i < n; i++)
			{
				var popupChildInfo:PopupChildInfo = _popupChildInfos[i];
				var window:DisplayObject = popupChildInfo.window;
				var modalSkin:DisplayObject = popupChildInfo.relatedModalSkin;
				var isModalMode:Boolean = popupChildInfo.isModalMode;
				var constrainType:String = popupChildInfo.constrainType;
				var isAlwaysConstrain:Boolean = popupChildInfo.isAlwaysConstrain;
				
				if(isModalMode)
				{
					LayoutUtil.setDisplayObjectLayout(modalSkin, 0, 0, layoutWidth, layoutHeight);
				}

				var preWindowW:Number = LayoutUtil.getDisplayObjectWidth(window);
				var preWindowH:Number = LayoutUtil.getDisplayObjectWidth(window);
				
				//支持百分比
				var windowW:Number = 0;
				var windowH:Number = 0;
				
				var windowPW:Number = LayoutUtil.getDisplayObjectPercentInWidth(window);
				if(isNaN(windowPW))
				{
					windowW = LayoutUtil.getDisplayObjectMeasuredWidth(window);
				}
				else
				{
					windowW = LayoutUtil.calculatePercentSizeInFullSize(windowPW, layoutWidth);
				}
				
				var windowPH:Number = LayoutUtil.getDisplayObjectPercentInHeight(window);
				if(isNaN(windowPH))
				{
					windowH = LayoutUtil.getDisplayObjectMeasuredHeight(window);
				}
				else
				{
					windowH = LayoutUtil.calculatePercentSizeInFullSize(windowPW, layoutHeight);
				}
				
				//不会做大小限制
				LayoutUtil.setDisplayObjectSize(window, windowW, windowH);
				
				var hasSizeChanged:Boolean = preWindowW != windowW || preWindowH != windowH;
				
				//isAlwaysConstrain = flase 只会更新一次，isAlwaysConstrain = true,不理会isPopUped
				if(hasSizeChanged || isAlwaysConstrain || !popupChildInfo.isPopUped)
				{
					layoutWindowPostion(window, windowW, windowH, layoutWidth, layoutHeight, constrainType);
				}
				
				if(!popupChildInfo.isPopUped)
				{
					popupChildInfo.isPopUped = true;
				}
			}
		}
		
		private function layoutWindowPostion(window:DisplayObject, windowW:Number, windowH:Number, layoutWidth:Number, layoutHeight:Number, constrainType:String):void
		{
			switch(constrainType)
			{
				case PositionConstrainType.CENTER:
					LayoutUtil.setDisplayObjectPosition(window, (layoutWidth - windowW) / 2, (layoutHeight - windowH) / 2);
					break;
				
				case PositionConstrainType.TOP_LEFT:
					LayoutUtil.setDisplayObjectPosition(window, 0, 0);
					break;
				
				case PositionConstrainType.TOP_RIGHT:
					LayoutUtil.setDisplayObjectPosition(window, layoutWidth - windowW, 0);
					break;
				
				case PositionConstrainType.BOTTOM_LEFT:
					LayoutUtil.setDisplayObjectPosition(window, 0, layoutHeight - windowH);
					break;
				
				case PositionConstrainType.BOTTOM_RIGHT:
					LayoutUtil.setDisplayObjectPosition(window, layoutWidth - windowW, layoutHeight - windowH);
					break;
				
				case PositionConstrainType.TOP_CENTER:
					LayoutUtil.setDisplayObjectPosition(window, (layoutWidth - windowW) / 2, 0);
					break;
				
				case PositionConstrainType.TOP_CUSTOM:
					LayoutUtil.setDisplayObjectPosition(window, window.x, 0);
					break;
				
				case PositionConstrainType.TOP_CUSTOM_LIMITED:
					LayoutUtil.ajustChildPostionInLimitShowArea2(window, window.x, 0, layoutWidth, layoutHeight);
					break;
				
				case PositionConstrainType.BOTTOM_CENTER:
					LayoutUtil.setDisplayObjectPosition(window, (layoutWidth - windowW) / 2, layoutHeight - windowH);
					break;
				
				case PositionConstrainType.BOTTOM_CUSTOM:
					LayoutUtil.setDisplayObjectPosition(window, window.x, layoutHeight - windowH);
					break;
				
				case PositionConstrainType.BOTTOM_CUSTOM_LIMITED:
					LayoutUtil.ajustChildPostionInLimitShowArea2(window, window.x, layoutHeight - windowH, layoutWidth, layoutHeight);
					break;
				
				case PositionConstrainType.LEFT_CENTER:
					LayoutUtil.setDisplayObjectPosition(window, 0, (layoutHeight - windowH) / 2);
					break;
				
				case PositionConstrainType.LEFT_CUSTOM:
					LayoutUtil.setDisplayObjectPosition(window, 0, window.y);
					break;
				
				case PositionConstrainType.LEFT_CUSTOM_LIMITED:
					LayoutUtil.ajustChildPostionInLimitShowArea2(window, 0, window.y, layoutWidth, layoutHeight);
					break;
				
				case PositionConstrainType.RIGHT_CENTER:
					LayoutUtil.setDisplayObjectPosition(window, layoutWidth - windowW, (layoutHeight - windowH) / 2);
					break;
				
				case PositionConstrainType.RIGHT_CUSTOM:
					LayoutUtil.setDisplayObjectPosition(window, layoutWidth - windowW, window.y);
					break;
				
				case PositionConstrainType.RIGHT_CUSTOM_LIMITED:
					LayoutUtil.ajustChildPostionInLimitShowArea2(window, layoutWidth - windowW, window.y, layoutWidth, layoutHeight);
					break;
				
				case PositionConstrainType.CUSTOM_LIMITED:
					LayoutUtil.ajustChildPostionInLimitShowArea2(window, window.x, window.y, layoutWidth, layoutHeight);
					break;
				
				default://CUSTOM
					break;
			}
		}
		
		private function getWindowPopupChildInfosIndex(window:DisplayObject):int
		{
			if(window == null) return -1;
			
			var n:uint = _popupChildInfos.length;
			for(var i:uint = 0; i < n; i++)
			{
				var popupChildInfo:PopupChildInfo = _popupChildInfos[i];
				if(popupChildInfo.window == window)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		private function getGlobalStyle(styleProp:String):*
		{
			if(application != null && application.styleManager != null)
			{
				var globalCSSStyleDeclaration:CSSStyleDeclaration = application.styleManager.getGlobalStyleDeclaration();
				if(globalCSSStyleDeclaration == null) return undefined;
				
				return globalCSSStyleDeclaration.getStyle(styleProp);
			}
			
			return undefined;
		}
		
		//event
		private function applicationMouseDownHandler(event:MouseEvent):void
		{
			if(this.numChildren > 0)
			{
				var target:DisplayObject = event.target as DisplayObject;
				
				//这里有可能出现触发事件时也操作了_popupChildInfos
				for each(var popupChildInfo:PopupChildInfo in _popupChildInfos)
				{
					var window:DisplayObjectContainer = DisplayObjectContainer(popupChildInfo.window);
					if(popupChildInfo.isPopUped && window.visible && !window.contains(target))
					{
						if(window.hasEventListener(ViburnumMouseEvent.POPUP_CHILD_MOUSE_DOWN_OUTSIDE))
						{
							var viburnumMouseEvent:ViburnumMouseEvent = new ViburnumMouseEvent(ViburnumMouseEvent.POPUP_CHILD_MOUSE_DOWN_OUTSIDE);
							viburnumMouseEvent.relatedObject = target as InteractiveObject;
							window.dispatchEvent(viburnumMouseEvent);
						}
					}
				}
			}
		}
	}
}

import com.viburnum.layouts.PositionConstrainType;

import flash.display.DisplayObject;

internal class PopupChildInfo
{
	public var window:DisplayObject = null;
	public var relatedModalSkin:DisplayObject = null;
	public var isModalMode:Boolean = false;
	
	public var constrainType:String = PositionConstrainType.CUSTOM;
	public var isAlwaysConstrain:Boolean = false;
	public var isPopUped:Boolean = false;
	
	public function PopupChildInfo(window:DisplayObject, 
								   relatedModalSkin:DisplayObject = null,
								   isModalMode:Boolean = false)
	{
		this.window = window;
		this.relatedModalSkin = relatedModalSkin;
		this.isModalMode = isModalMode;
	}
}