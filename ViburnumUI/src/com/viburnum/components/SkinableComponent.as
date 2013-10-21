package com.viburnum.components
{
    import com.alex.utils.ClassFactory;
    import com.viburnum.interfaces.IStateClient;
    import com.viburnum.interfaces.IStyleClient;
    import com.viburnum.interfaces.IStyleNotifyer;
    import com.viburnum.skins.ISkin;
    import com.viburnum.style.CSSStyleDeclaration;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;

	[Style(name="errorSkin", type="Class", skinClass="true", isDynamic="true")]
	[Style(name="focusSkin", type="Class", skinClass="true", isDynamic="true")]

	/**
	 * SkinableComponent是一个支持皮肤和样式定义的组件.
	 * 
	 * <p>SkinableComponent中的样式定义分为静态样式(static)和动态样式(isDynamic)定义,
	 * 默认是静态的。声明为静态样式是指，样式对应的皮肤在组件创建时就去创建的(有可能创建失败,因为样式指定为空),
	 * 而动态样式则是在需要的时候去手动创建和移除的。</p>
	 * 
	 * <p>样式定义的规则:</p>
	 * 
	 * 	<ul>
	 * 		<li>1.样式被定义为<code>[Style(name="errorSkin", type="Class", skinClass="true", isDynamic="true")]</code>类似的元标签声明格式。</li>
	 * 
	 * 		<li>2.如果该样式是皮肤样式，则需要在该类中显示(必须声明为public)定义与之相关的皮肤显示对象,
	 * 而且必须声明type="Class", skinClass="true";如：public var errorSkin:DisplayObject;</li>
	 * 
	 * 		<li>3.如果该皮肤样式不是静态创建的而是更具具体的逻辑去动态添加和删除的，则需要在Style内部里面声明isDynamic="true",如:
	 * [Style(name="errorSkin", type="Class", skinClass="true", isDynamic="true")],
	 * 然后通过generateValidDynamicSkinPartNow(skinPartName)和removeSkinPart(skinPartName)添加和移除。</li>
	 * 
	 * 		<li>4.该组件所有希望受样式控制的皮肤都必须在Style元标签里面定义，不然不会受影响。</li>
	 * 
	 * 		<li>5.有些皮肤可能是基于状态的，比如Button的皮肤，可以做如下设置:
	 * 		<pre>
	 * 			[Style(name="backgroundSkin", type="Class", skinClass="true")]
	 * 			[Style(name="backgroundSkin_upSkin", type="Class")]
	 * 			[Style(name="backgroundSkin_overSkin", type="Class")]
	 * 			[Style(name="backgroundSkin_downSkin", type="Class")]
	 * 			[Style(name="backgroundSkin_disabledSkin", type="Class")]
	 * 		</pre>
	 * 		子状态的skin是包含在主Skin(type="Class", skinClass="true")的backgroundSkin中的，而且子状态的skin的名称要按照Skin_子皮肤状态名称来声明,
	 * 		这样就可以在状态改变时自动切换到主Skin对应的状态(upSkin、overSkin、downSkin、disabledSkin)Skin了。
	 * 		但是前提是backgroundSkin 要赋值为框架的StateableProgrammaticSkin。</li>
	 * 
	 * 		<li>6.皮肤的样式设置默认会调用invalidateSize()和invalidateDisplayList()的。有些样式在设置时也希望调用这些函数，则需要在
	 * 		声明中这样设置:<pre>[Style(name="paddingLeft", type="Number", invalidateSize="true", invalidateDisplayList="true")]</pre></li>
	 * 
	 * 		<li>7.符合命名空间的样式声明，比如：
	 * 		<pre>
	 * 		[Style(name="backgroundSkin", type="Class", skinClass="true")]
	 * 		[Style(name="backgroundSkin_backgroundAlpha", type="Number")]
	 * 		[Style(name="backgroundSkin_backgroundColor", type="uint", format="Color")]
	 * 		[Style(name="backgroundSkin_backgroundImage", type="Class")]
	 * 		[Style(name="backgroundSkin_backgroundImageFillMode", type="String", enumeration="scale,clip,repeat")]
	 * 		</pre>
	 * 		这样样式的改变会映射到主Skin([Style(name="backgroundSkin", type="Class", skinClass="true")])的样式中了，
	 * 	并且样式被过滤为backgroundAlpha、backgroundColor、backgroundImage、backgroundImageFillMode等。参考5也是同样的规律。</li>
	 * 
	 * 		<li>8.在被声明为主Skin的子Skin里面没有必要声明invalidateSize="true", invalidateDisplayList="true",因为主Skin会帮你检测。</li>
	 * </ul>
	 * 
	 * <p>SkinableComponent默认定义了动态样式errorSkin， focusSkin</p>
	 * 
	 * @author zhangcheng01
	 * 
	 */	
    public class SkinableComponent extends UIComponent implements IStyleClient, IStyleNotifyer, IStateClient
    {
		private static const STYLE_METADATA_SKIN_CLASS:String = "skinClass";
		private static const STYLE_METADATA_IS_DYNAMIC:String = "isDynamic";
		private static const STYLE_METADATA_INVALIDATE_SZIE:String = "invalidateSize";
		private static const STYLE_METADATA_INVALIDATE_DISPLAYLIST:String = "invalidateDisplayList";

		public static function getStyleDefinition():Array 
		{
			return [
				{name:"errorSkin", type:"Class", skinClass:true, isDynamic:true},
				{name:"focusSkin", type:"Class", skinClass:true, isDynamic:true},
			]
		}
		
		//--
		
		public var errorSkin:DisplayObject;
		public var focusSkin:DisplayObject;
		
		private var _classStyleMetadataInfosCache:Object = null;
		private var _classesTypeList:Array;

        private var _styleName:Object;//CSSStyleDeclaration|String|(Hash)Object
		private var _styleNameChangedFlag:Boolean = false;

        //该实例所有样式的集合
        private var _inheritingStyles:CSSStyleDeclaration = new CSSStyleDeclaration(null);
        private var _nonInheritingStyles:CSSStyleDeclaration = new CSSStyleDeclaration(null);
		
        //该实例通过setStyle设置的样式，最终用于样式优先级
        private var _inlineStyles:CSSStyleDeclaration = new CSSStyleDeclaration(null);

		private var _currentState:String = null;
		private var _currentStateChangedFlag:Boolean = false;
		
		private var _skinInitialized:Boolean = false;
		
		private var _errorString:String = null;
		private var _errorStringChangedFlag:Boolean = false;
		
		private var _allSkinPartsVisualStateChanegdFlag:Boolean = false;
		
        public function SkinableComponent()
       	{
            super();

			tabEnabled = this is IFocusManagerComponent;
			tabChildren = this is IFocusManagerContainer;
        }

		public function get inheritingStyles():CSSStyleDeclaration
		{
			return _inheritingStyles;
		}

		public function get nonInheritingStyles():CSSStyleDeclaration
		{
			return _nonInheritingStyles;
		}

		public function get errorString():String
		{
			return _errorString;	
		}

		[Inspectable(type="String")]
		public function set errorString(value:String):void
		{
			_errorString = value;

			_errorStringChangedFlag = true;
			invalidateProperties();
		}
		
		//IStyleClient Interface================================================
		public function get styleName():Object
		{
			return _styleName;
		}

		[Inspectable(type="String")]
		public function set styleName(value:Object/*String CSSStyleDeclaration*/):void
		{
			if(_styleName != value)
			{
				_styleName = value;
				
				if(!_skinInitialized) return;//皮肤初始化时会做一次更新
				
				_styleNameChangedFlag = true;
				invalidateProperties();
			}
		}

		public function getStyle(styleProp:String):*
		{
			var isInheritingStyleProp:Boolean = styleManager != null ?
				styleManager.isInheritingStyleProp(styleProp) :
				false;
			
			if(isInheritingStyleProp)
			{
				return _inheritingStyles?
					_inheritingStyles.getStyle(styleProp):
					undefined;
			}
			else
			{
				return _nonInheritingStyles?
					_nonInheritingStyles.getStyle(styleProp):
					undefined;
			}
		}
		
		//line style here
		public function setStyle(styleProp:String, newValue:*):void
		{
			if(!styleProp || styleProp == "styleName") return;//styleProp == styleName 走 set styleName

			var stylePropValue:* = getStyle(styleProp);
			var changed:Boolean = stylePropValue != newValue;
			
			if(changed)
			{
				_inlineStyles.setStyle(styleProp, newValue);
				
				if(!_skinInitialized) return;//皮肤创建标记

				regenerateStylesProtoChain();

				var isInheritingStyleProp:Boolean = styleManager != null ?
					styleManager.isInheritingStyleProp(styleProp) :
					false;

				//通知自己样式改变
				notifyStyleChanged(styleProp);
				//通知所有child继承样式改变
				notifyStyleChangedInChildren(styleProp, isInheritingStyleProp);
			}
		}
		
		public function clearStyle(styleProp:String):void
		{
			setStyle(styleProp, undefined);
		}
		
		//IStyleNotifyer Interface================================================
		//
		/**
		 * 运行时样式改变或在初始化时会在遍历所有样式调用该函数.
		 * 
		 * 该函数是框架负责调用的，用户不用手动去调用。
		 *  
		 * @param styleProp 样式名称
		 * 
		 */
		public function notifyStyleChanged(styleProp:String):void
		{
			if(_classStyleMetadataInfosCache == null) return;

			var styleMetadataItem:Object = _classStyleMetadataInfosCache[styleProp];
			if(!styleMetadataItem) return;
			
			var isValidSkinPart:Boolean = checkIsValidSkinPartByStyleItem(styleMetadataItem);
			if(isValidSkinPart) regenerateValidSkinPart(styleProp);
			
			if(_skinInitialized)
			{
				var needinvalidateSize:Boolean = styleMetadataItem[STYLE_METADATA_INVALIDATE_SZIE] != undefined;;
				if(needinvalidateSize) invalidateSize();
				
				var needinvalidateDisplayList:Boolean = styleMetadataItem[STYLE_METADATA_INVALIDATE_DISPLAYLIST] != undefined;
				if(needinvalidateDisplayList) invalidateDisplayList();
			}
		}
		
		//IStateClient Interface================================================
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if(_currentState != value)
			{
				_currentState = value;
				
				_currentStateChangedFlag = true;
				invalidateProperties();	
			}
		}
		
		//IFocusManagerComponent Interface================================================
		public function get focusEnabled():Boolean
		{
			return true;
		}
		
		public function set focusEnabled(value:Boolean):void
		{
		}
		
		public function get hasFocusableChildren():Boolean
		{
			return false;	
		}
		
		
		public function set hasFocusableChildren(value:Boolean):void
		{
		}
		
		public function get mouseFocusEnabled():Boolean
		{
			return true;
		}
		
		public function get tabFocusEnabled():Boolean
		{
			return true;
		}
		
		public function drawFocus(isFocused:Boolean):void
		{
		}

		override public function regenerateStyleCache(needUpdateSkinImmediately:Boolean):void
        {
			if(_skinInitialized)
			{
				regenerateStylesProtoChain();
				
				if(needUpdateSkinImmediately)
				{
					regenerateAllSkins();
				}
			}

			super.regenerateStyleCache(needUpdateSkinImmediately);
        }
		
        //刷性样式继承连
        //inline > styleName > Class(1-n) > parent(继承) > global
        private function regenerateStylesProtoChain():void
        {
//			var globalSelector:CSSStyleDeclaration = styleManager != null ? 
//				styleManager.getGlobalStyleDeclaration() :
//				null;
//			
//			//global style
//			if(globalSelector != null)
//			{
//				_nonInheritingStyles.mergeInheritingStyle(globalSelector);
//			}
			
			//owner || parent style, owner first
			var p:DisplayObjectContainer = (owner != null) ? owner : parent;
			while(p != null)
			{
				if(p is SkinableComponent)
				{
					break;
				}
				
				p = p.parent;
			}
			
			if(p != null && p is SkinableComponent)
			{
				_inheritingStyles.overrideStyleProps(SkinableComponent(p).inheritingStyles);
			}

			//Class(selfClass And super Class) style
			var classesSelector:CSSStyleDeclaration = styleManager != null ? 
				styleManager.getHeritingClassTypeListStyleDeclaration(this) : null;
			if(classesSelector != null)
			{
				if(styleManager != null)
				{
					_inheritingStyles.overrideStyleProps(styleManager.getFilteredStyleDeclaration(classesSelector, true));
					_nonInheritingStyles.overrideStyleProps(styleManager.getFilteredStyleDeclaration(classesSelector, false));	
				}
				else
				{
					_nonInheritingStyles.overrideStyleProps(classesSelector);
				}
			}

			//type(styleName) style
			if(_styleName != null)
			{
				var styleNameSelector:CSSStyleDeclaration = null;
				if(_styleName is CSSStyleDeclaration)
				{
					styleNameSelector = CSSStyleDeclaration(styleName);
				}
				else if(_styleName is String)
				{
					if(styleManager != null)
					{
						styleNameSelector = styleManager.getStyleDeclaration(String(styleName));	
					}
				}
				else if(_styleName is Object)
				{
					styleNameSelector = new CSSStyleDeclaration(_styleName);
				}

				if(styleNameSelector != null)
				{
					if(styleManager != null)
					{
						_inheritingStyles.overrideStyleProps(styleManager.getFilteredStyleDeclaration(styleNameSelector, true));
						_nonInheritingStyles.overrideStyleProps(styleManager.getFilteredStyleDeclaration(styleNameSelector, false));
					}
					else
					{
						_nonInheritingStyles.overrideStyleProps(styleNameSelector);
					}
				}
			}

            //inline Style
//			trace("regenerateStylesProtoChain", styleManager);
			if(styleManager != null)
			{
				_inheritingStyles.overrideStyleProps(styleManager.getFilteredStyleDeclaration(_inlineStyles, true));
				_nonInheritingStyles.overrideStyleProps(styleManager.getFilteredStyleDeclaration(_inlineStyles, false));
			}
			else
			{
				_nonInheritingStyles.overrideStyleProps(_inlineStyles);
			}
        }

        //Template Method=======================================================
		protected function getCurrentSkinState():String
		{
			return "";
		}
		
		override protected function onPreInitialize():void
		{
			super.onPreInitialize();
			
			if(styleManager != null)
			{
				styleManager.registComponent(this);
				
				_classStyleMetadataInfosCache = styleManager.getHeritingClassStyleMetadataInfos(this);
			}
		}
		
		override protected function onInitializeComplete():void
		{
			super.onInitializeComplete();
			
			if(tabEnabled)
			{
				this.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				this.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				this.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				this.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
		}
		
		override public function validateProperties():void
		{
			//ensure skin skinInitialized is the first one to be deal with
			//皮肤初始化必须第一次被处理
			if(!_skinInitialized)
			{
				regenerateStylesProtoChain();
				regenerateAllSkins();
				_skinInitialized = true;
//				trace("Skin first init");
			}
			
			super.validateProperties();
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_currentStateChangedFlag)
			{
				_currentStateChangedFlag = false;
				currentStateChanged();
			}
			
			if(_styleNameChangedFlag)
			{
				_styleNameChangedFlag = false;
				
				regenerateStylesProtoChain();
				regenerateAllSkins();
			}
			
			if(_errorStringChangedFlag)
			{
				_errorStringChangedFlag = false;
				errorStringChanged();
			}
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			if(_allSkinPartsVisualStateChanegdFlag)
			{
				updateAllSkinPartsVisualState();
			}
		}
		
		protected function currentStateChanged():void
		{
			synAllValidateSkinPartsByCurrentSate();
		}
		
		private function synAllValidateSkinPartsByCurrentSate():void
		{
			for each(var styleMetadataItem:Object in _classStyleMetadataInfosCache)
			{
				var styleProp:String = styleMetadataItem.name;
				var isValidateSkinPart:Boolean = checkIsValidSkinPartByStyleItem(styleMetadataItem);
				if(isValidateSkinPart)
				{
					// 这里的styleProp即为验证后的skinPartName
					if(this[styleProp] != null)
					{
						skinStateChanged(styleProp, this[styleProp], _currentState);
					}
				}
			}
		}
		
		/**
		 *  
		 * @param skinPartName
		 * @param skin
		 * @param skinState 默认为当前组件的状态，可以在子类中覆盖，改写skinState具体值
		 * 
		 */		
		protected function skinStateChanged(skinPartName:String, skin:DisplayObject, skinState:String):void
		{
			if(skin is IStateClient)
			{
				IStateClient(skin).currentState = skinState;
			}
		}
		
		protected function errorStringChanged():void
		{
		}
		
		private function regenerateAllSkins():void
		{
//			TimeUtil.recordCurrentRunTime(this.name);
//			trace("regenerateAllSkins", _classStyleMetadataInfosCache);
			for each(var styleMetadataItem:Object in _classStyleMetadataInfosCache)
			{
				var styleProp:String = styleMetadataItem.name;
				notifyStyleChanged(styleProp);
//				trace("notifyStyleChanged", styleProp);
			}

//			TimeUtil.recordCurrentRunTime(this.name);
//			trace(this.name, TimeUtil.getRecordedTotalRunTime(this.name));
		}

		/**
		 * 更新静态皮肤。
		 * 
		 * 在有些时候需要手动更新静态皮肤，比如静态皮肤是由用户具体指定和样式决定的时候。
		 *  
		 * @param skinPartName
		 * @param skinFactory
		 * 
		 */		
		protected final function updateValidStaticSkinPartNow(skinPartName:String, skinFactory:Class = null):void
		{
			var isDynamicSkinPart:Boolean = checkIsValidSkinPartBySkinPartName(skinPartName, true);
			if(isDynamicSkinPart) return;
			
			destoryValidSkinPart(skinPartName);
			generateValidSkinPart(skinPartName, false, skinFactory);
		}
		
		/**
		 * 需要在创建动态皮肤的时候调用.
		 * 
		 * <p>动态皮肤的创建可能不是伴随组件声明周期的，
		 * 在样式改变时创建动态皮肤的策略是，如果已经有定义的该动态皮肤则立即更新该动态皮肤,
		 * 如果没有则等待用户自己去手动更新,也会这里是唯一可以自己控制皮肤什么时候创建的地方。</p>
		 * 
		 * <p>这里应为是显示去调用创建动态皮肤，所以应该是刷新皮肤(会将已经有删除)</p>
		 * 
		 * @param skinPartName
		 * @param skinFactory 如果指定具体Class则从该Class生成否则从style,默认为null（从Style获取）
		 * 
		 */
		protected final function generateValidDynamicSkinPartNow(skinPartName:String, skinFactory:Class = null):void
		{
			var isDynamicSkinPart:Boolean = checkIsValidSkinPartBySkinPartName(skinPartName, true);
			if(!isDynamicSkinPart) return;

			destoryValidSkinPart(skinPartName);
			
			generateValidSkinPart(skinPartName, true, skinFactory);
		}
		
		protected final function destoryValidDynamicSkinPartNow(skinPartName:String):void
		{
			var isDynamicSkinPart:Boolean = checkIsValidSkinPartBySkinPartName(skinPartName, true);
			if(!isDynamicSkinPart) return;
			
			destoryValidSkinPart(skinPartName);
		}

		//static skin part or dynamic skin part
		//自身样式改变或刷新所有皮肤需要更新当前皮肤
		/**
		 *  重新生成皮肤包括动态和静态皮肤.
		 * 
		 *  如果动态皮肤存在则替换不存在则等待removeSkinPart后generateValidDynamicSkinPartNow实现刷新。
		 * 
		 * @param skinPartName
		 * @param skinClass 如果指定具体Class则从该Class生成否则从style,默认为null（从Style获取）
		 * 
		 */		
		private function regenerateValidSkinPart(skinPartName:String):void
		{
			var needGenerateSkinPartNow:Boolean = true;

			var isDynamicSkinPart:Boolean = checkIsValidSkinPartBySkinPartName(skinPartName, true);
			//动态皮肤的创建需要根据之前是否动态皮肤决定是否创建
			if(isDynamicSkinPart && this[skinPartName] == null)
			{
				needGenerateSkinPartNow = false;
			}

			//必须先移除已经有的皮肤
			destoryValidSkinPart(skinPartName);

			if(needGenerateSkinPartNow) generateValidSkinPart(skinPartName);
		}
		
		/**
		 * 刷新动态和静态皮肤.
		 *  
		 * @param skinPartName 皮肤的名称
		 * @param skinClass 指定的皮肤Class，若有则从该Class生成，没有则从Style里面取值
		 * 
		 */		
		private function generateValidSkinPart(skinPartName:String, isDynamic:Boolean = false, skinFactory:Class = null):void
		{
//			trace("generateValidSkinPart", skinPartName, isDynamic, skinFactory, getStyle(skinPartName));
			
			if(this[skinPartName] != null) return;//生成之前必须先移除，否则不会起作用
			
			//这里皮肤的生成可能是Class或ClassFactory(ClassFactory可以做些配置),如果具体指定则使用skinClass,否则从getStyle中取
			var skinFactoryCls:* /*Class or ClassFactory*/ = skinFactory || getStyle(skinPartName);
			//不管工厂是什么最后的instance必须是DisplayObject类型
			if(skinFactoryCls is Class)
			{
				this[skinPartName] = DisplayObject(new skinFactoryCls());
			}
			else if(skinFactoryCls is ClassFactory)
			{
				this[skinPartName] = DisplayObject(ClassFactory(skinFactoryCls).newInstance());
			}

			if(this[skinPartName] == null) return;
			
			//皮肤是可以接受鼠标事件的,皮肤的内部不可以，也没有必要!
			if(this[skinPartName] is Sprite)
			{
				Sprite(this[skinPartName]).tabEnabled = false;
				Sprite(this[skinPartName]).tabChildren = false;
				Sprite(this[skinPartName]).mouseChildren = false;
			}

			//设置ISkin类型的皮肤
			if(this[skinPartName] is ISkin)
			{
				ISkin(this[skinPartName]).owner = this;
				ISkin(this[skinPartName]).skinPartName = skinPartName;
			}
			
			//同步新皮肤的状态
			skinStateChanged(skinPartName, this[skinPartName], _currentState);
			
			//皮肤默认被添加到最底层
			addChildAt(DisplayObject(this[skinPartName]), 0);
			
			//这里做一些自定一义的处理
			onSkinPartAttachToDisplayList(skinPartName, this[skinPartName]);

			_allSkinPartsVisualStateChanegdFlag = true;
			
			if(_skinInitialized)
			{
				//如果是静态皮肤，则需要度量，因为可能会依赖静态皮肤的尺寸
				if(!isDynamic) invalidateSize();
				
				invalidateDisplayList();
			}
		}
		
		private function destoryValidSkinPart(skinPartName:String):void
		{
			if(this[skinPartName] == null) return;
			
			removeChild(DisplayObject(this[skinPartName]));

			if(this[skinPartName] is ISkin)
			{
				ISkin(this[skinPartName]).owner = null;
			}
			
			//这里做最后的一些处理
			onSkinPartAttachToDisplayList(skinPartName, DisplayObject(this[skinPartName]));
			
			this[skinPartName] = null;	
		}
		
		/**
		 * 皮肤被添加。
		 * 
		 * 用户可以在这里做一些最后的处理。
		 * 
		 * @param skinPartName
		 * @param skin
		 * 
		 */		
		protected function onSkinPartAttachToDisplayList(skinPartName:String, skin:DisplayObject):void
		{
		}
		
		/**
		 * 移除并销毁皮肤.
		 * 
		 * 这里是皮肤被移除前的最后的操作。用户可以在这里做一些最后的处理。
		 * 
		 * @param skinPartName
		 * @param skin
		 * 
		 */		
		protected function onSkinPartDetachFromDisplayList(skinPartName:String, skin:DisplayObject):void
		{
		}

		/**
		 * 更新所有皮肤的视觉状态.
		 * 
		 * <p>一般发生在添加皮肤时框架调用，用户也可以在适当的时机手动调用。</p>
		 * 
		 */		
		protected function updateAllSkinPartsVisualState():void
		{
			_allSkinPartsVisualStateChanegdFlag = false;
		}

		/**
		 * @private
		 * 
		 * 检查是否是有效的皮肤，包括动态和静态.
		 *  
		 * @param skinPartName
		 * @param checkIsDynamicSkinPart
		 * @return 
		 * 
		 */			
		private function checkIsValidSkinPartBySkinPartName(skinPartName:String, checkIsDynamicSkinPart:Boolean = false):Boolean
		{
			if(_classStyleMetadataInfosCache == null) return false;
			
			var styleMetadataItem:Object = _classStyleMetadataInfosCache[skinPartName];
			var isValidSkinPart:Boolean = checkIsValidSkinPartByStyleItem(styleMetadataItem);
			if(!isValidSkinPart) return false;
			
			if(checkIsDynamicSkinPart)
			{
				var isDynamicSkinPart:Boolean = styleMetadataItem[STYLE_METADATA_IS_DYNAMIC] != undefined;
				if(!isDynamicSkinPart) return false;
			}
			
			return true;
		}

		private function checkIsValidSkinPartByStyleItem(styleItem:Object):Boolean
		{
			if(styleItem == null) return false;

			var skinPartName:String = styleItem.name;
		
			//1.必须显示声明且可访问
			var hasDefineSkinPart:Boolean = Boolean(skinPartName in this);
			if(!hasDefineSkinPart) return false;
			
			//2.metedata中type必须声明为class
			var skinPartType:String = styleItem.type;
			if(skinPartType != "Class") return false;

			//3.metedata中skinClass必须要声明
			var isSkinPartClass:Boolean = styleItem[STYLE_METADATA_SKIN_CLASS] != undefined;
			if(!isSkinPartClass) return false;

			return true;
		}
		
		//event handler
		protected function focusInHandler(event:FocusEvent):void
		{
//			trace("focusInHandler", this.name, event.eventPhase);
			if(isOurFocus(DisplayObject(event.target)))
			{
				if(focusManager != null && focusManager.showFocusIndicator)
				{
					drawFocus(true);
				}
			}
		}
		
		protected function isOurFocus(target:DisplayObject):Boolean
		{
			return target == this;
		}
		
		protected function focusOutHandler(event:FocusEvent):void
		{
			if(isOurFocus(DisplayObject(event.target)))
			{
//				trace(this, "focusOutHandler");
				drawFocus(false);
			}
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
		}
		
		protected function keyUpHandler(event:KeyboardEvent):void
		{
		}
		
		//helper method
		protected final function getDefaultStyle(styleProp:String, defaultValue:*):*
		{
			return getStyle(styleProp) || defaultValue;
		}
    }
}