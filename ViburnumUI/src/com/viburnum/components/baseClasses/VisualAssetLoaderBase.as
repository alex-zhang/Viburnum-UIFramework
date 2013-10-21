package com.viburnum.components.baseClasses
{
	import com.viburnum.components.HorizontalAlign;
	import com.viburnum.components.IVisualAssetLoader;
	import com.viburnum.components.VerticalAlign;
	import com.viburnum.interfaces.ILayoutElement;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.system.LoaderContext;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="init", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="unload", type="flash.events.Event")]
	[Event(name="uncaughtError", type="flash.events.UncaughtErrorEvent")]
	
	include "../../style/styleMetadata/VerticalAlignStyle.as";
	include "../../style/styleMetadata/HorizontalAlignStyle.as";
	
	[Style(name="brokenSkin", type="Class", skinClass="true")]
	
	public class VisualAssetLoaderBase extends BorderComponentBase implements IVisualAssetLoader
	{
		public static function getStyleDefinition():Object 
		{
			return [
				//VerticalAlignStyle
				{name:"verticalAlign", type:"String", enumeration:"bottom,middle,top", invalidateDisplayList:"true"},
				
				//HorizontalAlignStyle
				{name:"horizontalAlign", type:"String", enumeration:"left,center,right", invalidateDisplayList:"true"},
			]
		}
		
		public var brokenSkin:DisplayObject;
		
		protected var contentHolder:DisplayObject;
		
		private var _source:Object;
		private var _sourceChangedFlag:Boolean = false;
		
		private var _bytesLoaded:Number = NaN;
		private var _bytesTotal:Number = NaN;
		
		private var _loaderContext:LoaderContext;
		
		private var _maintainAspectRatio:Boolean = true;
		private var _maintainAspectRatioChanegdFlag:Boolean = false;
		
		private var _smoothBitmapContent:Boolean = false;
		private var _smoothBitmapContentChangedFlag:Boolean = false;
		
		private var _scaleContent:Boolean = false;
		private var _scaleContentChangedFlag:Boolean = false;
		
		private var _isContentLoaded:Boolean = false;
		private var _isContentLoadError:Boolean = false;
		
		public function VisualAssetLoaderBase()
		{
			super();
		}

		//IVisualAssetLoader Interface
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		public function get percentLoaded():Number
		{
			var p:Number = isNaN(_bytesTotal) || _bytesTotal == 0 ?
				0 :
				100 * (_bytesLoaded / _bytesTotal);
			
			if(isNaN(p))
			{
				p = 0;
			}
			
			return p;
		}
		
		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}
		
		public function set loaderContext(value:LoaderContext):void
		{
			_loaderContext = value;
		}
		
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}
		
		[Inspectable(type="Boolean", defaultValue="true")]
		public function set maintainAspectRatio(value:Boolean):void
		{
			if(_maintainAspectRatio != value)
			{
				_maintainAspectRatio = value;
				invalidateDisplayList();
			}
		}
		
		public function get scaleContent():Boolean
		{
			return _scaleContent;
		}
		
		[Inspectable(type="Boolean", defaultValue="false")]
		public function set scaleContent(value:Boolean):void
		{
			if (_scaleContent != value)
			{
				_scaleContent = value;
				
				_scaleContentChangedFlag = true;
				invalidateDisplayList();
			}
		}
		
		public function get smoothBitmapContent():Boolean
		{
			return _smoothBitmapContent;
		}
		
		[Inspectable(type="Boolean", defaultValue="false")]
		public function set smoothBitmapContent(value:Boolean):void
		{
			if(_smoothBitmapContent != value)
			{
				_smoothBitmapContent = value;
				
				_smoothBitmapContentChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get content():DisplayObject
		{
			if (contentHolder is Loader)
			{
				return Loader(contentHolder).content;
			}
			
			return contentHolder;
		}
		
		[Inspectable(type="Object")]
		public function set source(value:Object):void
		{
			if(_source != value)
			{
				_source = value;
				
				_sourceChangedFlag = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList()
			}
		}
		
		public function get source():Object
		{
			return _source;
		}
		
		public function load(url:Object = null):void
		{
			_source = url;
			
			unloadContent();
			
			if (_source == null || _source == "") return;
			
			loadContent(_source);
		}
		
		private function unloadContent():void
		{
			_isContentLoaded = false;
			_isContentLoadError = false;
			_loaderContext = null;
			
			setbrokenSkinVisiableByLoadErrorFlag();
			
			onUnloadContent();
		}
		
		protected function onUnloadContent():void
		{
			if(contentHolder != null)
			{
				contentHolder.filters = null;
				
				if(contentHolder is Loader)
				{
					if(Loader(contentHolder).content is Bitmap && Bitmap(Loader(contentHolder).content) != null)
					{
						Bitmap(Loader(contentHolder).content).bitmapData.dispose();
						Bitmap(Loader(contentHolder).content).bitmapData = null;
					}
					
					Loader(contentHolder).contentLoaderInfo.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, contentLoaderInfoUncaughtErrorHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(Event.INIT, contentLoaderInfoInitEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(Event.OPEN, contentLoaderInfoOpenEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(Event.COMPLETE, contentLoaderInfoCompleteEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(Event.UNLOAD, contentLoaderInfoUnloadEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfoSecurityErrorEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, contentLoaderInfoIoErrorEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, contentLoaderInfoHttpStatusEventHandler);
					Loader(contentHolder).contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, contentLoaderInfoProgressEventHandler);
					Loader(contentHolder).unloadAndStop(true);
					
					try
					{
						Loader(contentHolder).close();
					}
					catch(error:Error) 
					{
					}
				}
			}
		}
		
		//must clean load here
		private function loadContent(source:Object):void
		{
			onLoadContent(source);
		}
		
		protected function onLoadContent(source:Object):void
		{
			if(contentHolder != null && contentHolder is Loader)
			{
				Loader(contentHolder).contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, contentLoaderInfoUncaughtErrorHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(Event.INIT, contentLoaderInfoInitEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(Event.OPEN, contentLoaderInfoOpenEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaderInfoCompleteEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(Event.UNLOAD, contentLoaderInfoUnloadEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfoSecurityErrorEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, contentLoaderInfoIoErrorEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, contentLoaderInfoHttpStatusEventHandler);
				Loader(contentHolder).contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, contentLoaderInfoProgressEventHandler);
			}
		}
		
		override protected function onSkinPartAttachToDisplayList(skinPartName:String, skin:DisplayObject):void
		{
			if(skinPartName == "brokenSkin")
			{
				setbrokenSkinVisiableByLoadErrorFlag();
			}
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.sortDisplayObjectChildren(this, brokenSkin, brokenSkin);
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_sourceChangedFlag)
			{
				_sourceChangedFlag = false;
				load(_source);
			}
			
			if(_smoothBitmapContentChangedFlag)
			{
				_smoothBitmapContentChangedFlag = false;
				updateContentHolderSmooth();
			}
		}

		protected function getContentHolderWidth():Number
		{
			if(!_isContentLoaded) return 0;
			
			var loaderInfo:LoaderInfo = null;
			if(contentHolder is Loader)
			{
				loaderInfo = Loader(contentHolder).contentLoaderInfo;
			}
			
			if(loaderInfo != null)
			{
				if(loaderInfo.contentType == "application/x-shockwave-flash")
				{
					if(loaderInfo.content is ILayoutElement)
					{
						return ILayoutElement(loaderInfo.content).measuredWidth;
					}
				}
				
				return loaderInfo.width;
			}
			
			return LayoutUtil.getDisplayObjectMeasuredWidth(contentHolder);
		}
		
		protected function getContentHolderHeight():Number
		{
			if(!_isContentLoaded) return 0;
			
			var loaderInfo:LoaderInfo = null;
			if(contentHolder is Loader)
			{
				loaderInfo = Loader(contentHolder).contentLoaderInfo;
			}
			
			if(loaderInfo != null)
			{
				if(loaderInfo.contentType == "application/x-shockwave-flash")
				{
					if(loaderInfo.content is ILayoutElement)
					{
						return ILayoutElement(loaderInfo.content).measuredHeight;
					}
				}
				
				return loaderInfo.height;
			}
			
			return LayoutUtil.getDisplayObjectMeasuredHeight(contentHolder);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var measuredW:Number = 0;
			var measuredH:Number = 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var contentHolderMW:Number = getContentHolderWidth();
			var contentHolderMH:Number = getContentHolderHeight();
			
			var brokenSkinMW:Number = 0;
			var brokenSkinMH:Number = 0;
			
			var gapW:Number = bl + br;
			var gapH:Number = bt + bb;
			
			if(_isContentLoadError)
			{
				brokenSkinMW = LayoutUtil.getDisplayObjectMeasuredWidth(brokenSkin);
				brokenSkinMH = LayoutUtil.getDisplayObjectMeasuredHeight(brokenSkin);
			}
			
			measuredW = Math.max(brokenSkinMW, contentHolderMW);
			measuredH = Math.max(brokenSkinMH, contentHolderMH);
			
			measuredW += gapW;
			measuredH += gapH;
			
			setMeasuredSize(measuredW, measuredH);
			
			//--
			
			var minW:Number = brokenSkinMW + gapW;
			var minH:Number = brokenSkinMH + gapH;
			
			setMeasuredMinSize(minW, minH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var contentLayoutWidth:Number = layoutWidth - bl - br;
			var contentLayoutHeight:Number = layoutHeight - bt - bb;
			
			if(_isContentLoadError && brokenSkin != null)
			{
				var brokenSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(brokenSkin);
				var brokenSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(brokenSkin);
				
				LayoutUtil.setDisplayObjectLayout(brokenSkin, 
					bl + (contentLayoutWidth - brokenSkinMW) * 0.5, 
					bt + (contentLayoutHeight - brokenSkinMH) * 0.5, 
					brokenSkinMW, brokenSkinMH);
			}
			
			if(_isContentLoaded && contentHolder != null)
			{
				if(_maintainAspectRatio)
				{
					var contentActualWidth:Number = getContentHolderWidth();
					var contentActualHeight:Number = getContentHolderHeight();
					
					if(_scaleContent)
					{
						var contentWHPercent:Number = contentActualWidth / contentActualHeight;
						var layoutWHPercent:Number = contentLayoutWidth / contentLayoutHeight;
						
						//这里contentWHPercent可能为NaN 为 0，则不显示但是逻辑是正确的
						//需要在应用该方式的流式布局
						if(contentWHPercent > layoutWHPercent)
						{
							contentActualWidth = contentLayoutWidth;
							contentActualHeight = contentActualWidth / contentWHPercent;
						}
						else
						{
							contentActualHeight = contentLayoutHeight;
							contentActualWidth = contentActualHeight * contentWHPercent;
						}
					}
					
					var offx:Number = 0;
					var offy:Number = 0;
					
					var horizontalAlign:String = getStyle("horizontalAlign");
					var verticalAlign:String = getStyle("verticalAlign");
					
					if(horizontalAlign == HorizontalAlign.CENTER)
					{
						offx = (contentLayoutWidth - contentActualWidth) / 2;
					}
					else if(horizontalAlign == HorizontalAlign.RIGHT)
					{
						offx = contentLayoutWidth - contentActualWidth;
					}
					
					if(verticalAlign == VerticalAlign.MIDDLE)
					{
						offy = (contentLayoutHeight - contentActualHeight) / 2;
					}
					else if(verticalAlign == VerticalAlign.BOTTOM)
					{
						offy = contentLayoutHeight - contentActualHeight;
					}
					
					offx += bl;
					offy += bt;
					
					updateContentHolderSizeAndPostion(offx, offy, contentActualWidth, contentActualHeight);
				}
				else
				{
					updateContentHolderSizeAndPostion(bl, bt, contentLayoutWidth, contentLayoutHeight);
				}
			}
		}
		
		protected function updateContentHolderSizeAndPostion(x:Number, y:Number, width:Number, height:Number):void
		{
			contentHolder.scaleX = 1;
			contentHolder.scaleY = 1;
			
			if(contentHolder is Loader && Loader(contentHolder).contentLoaderInfo.contentType == "application/x-shockwave-flash")
			{
				if(Loader(contentHolder).content is ILayoutElement)
				{
					contentHolder.x = 0;
					contentHolder.y = 0;
					
					LayoutUtil.setDisplayObjectLayout(Loader(contentHolder).content, x, y, width, height);
				}
				else
				{
					var loaderWidth:Number = getContentHolderWidth();
					var loaderHeight:Number = getContentHolderHeight();
					var scaleX:Number = width / loaderWidth;
					var scaleY:Number = height / loaderHeight;
					contentHolder.scaleX = scaleX;
					contentHolder.scaleY = scaleY;
					contentHolder.x = x;
					contentHolder.y = y;
				}
			}
			else
			{
				LayoutUtil.setDisplayObjectLayout(contentHolder, x, y, width, height);
			}
		}
		
		//update
		private function updateContentHolderSmooth():void
		{
			if(_isContentLoaded && content != null && content is Bitmap)
			{
				Bitmap(content).smoothing = _smoothBitmapContent;
			}
		}
		
		//event handler
		private function contentLoaderInfoOpenEventHandler(event:Event):void
		{
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
		}
		
		private function contentLoaderInfoInitEventHandler(event:Event):void
		{
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
		}
		
		private function contentLoaderInfoUncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
		}
		
		private function contentLoaderInfoCompleteEventHandler(event:Event):void
		{
			_isContentLoaded = true;
			_isContentLoadError = false;
			
			setbrokenSkinVisiableByLoadErrorFlag();
			updateContentHolderSmooth();
			
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function contentLoaderInfoIoErrorEventHandler(event:IOErrorEvent):void
		{
			_isContentLoaded = false;
			_isContentLoadError = true;
			
			setbrokenSkinVisiableByLoadErrorFlag();
			
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function contentLoaderInfoSecurityErrorEventHandler(event:SecurityErrorEvent):void
		{
			_isContentLoaded = false;
			_isContentLoadError = true;
			
			setbrokenSkinVisiableByLoadErrorFlag();
			
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function contentLoaderInfoUnloadEventHandler(event:Event):void
		{
			if(hasEventListener(Event.UNLOAD))
			{
				dispatchEvent(event);
			}
		}
		
		private function contentLoaderInfoHttpStatusEventHandler(event:HTTPStatusEvent):void
		{
			if(hasEventListener(HTTPStatusEvent.HTTP_STATUS))
			{
				dispatchEvent(event);
			}
		}
		
		private function contentLoaderInfoProgressEventHandler(event:ProgressEvent):void
		{
			_bytesTotal = event.bytesTotal;
			_bytesLoaded = event.bytesLoaded;
			
			if(hasEventListener(ProgressEvent.PROGRESS))
			{
				dispatchEvent(event);
			}
		}
		
		private function setbrokenSkinVisiableByLoadErrorFlag():void
		{
			if(brokenSkin != null) brokenSkin.visible = _isContentLoadError;
		}
	}
}