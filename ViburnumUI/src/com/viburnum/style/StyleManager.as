package com.viburnum.style
{
    import com.viburnum.components.IApplication;
    import com.viburnum.components.SkinableComponent;
    import com.viburnum.interfaces.IPluginEntity;
    import com.viburnum.utils.DescribeTypeUitil;
    import com.viburnum.utils.ObjectUtil;
    
    import flash.events.IEventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;

    public class StyleManager implements IStyleManager
    {
		protected var myApplication:IApplication;
		
        private var _inheritingStylesProps:Object = {};//prop => true
        private var _selectorstorCache:Object = {}; //selectorName => Obejct
		
		private var _classTypeHeritanceMap:Object = {};//classType => [];
		private var _classHeritanceStyleMeataInfoMap:Object = {};//classType => [];
        
		private var _styleModules:Object = {};
		
        private static const STYELE_ROOT_CLASS_TYPE:String = getQualifiedClassName(SkinableComponent);

        public function StyleManager()
        {
            super();
        }
		
		//IPluginComponent Interface
		public function get pluginEntity():IPluginEntity
		{
			return myApplication;
		}
		
		public function set pluginEntity(value:IPluginEntity):void
		{
			myApplication = value as IApplication;
		}
		
		public function onAttachToPluginEntity():void
		{
		}
		
		public function onDettachFromPluginEntity():void
		{
		}

		//注册类级别的 Meatadata信息
		//注册全局继承样式
		public function registComponent(component:SkinableComponent):void
		{
			var classType:String = getQualifiedClassName(component);
			
			var rootApplicationDomain:ApplicationDomain = component.loaderInfo.applicationDomain;
			
			registComponentWithClassTypeHeritance(classType, rootApplicationDomain);
			registComponentWithClassHeritanceStyleMeataInfo(classType, rootApplicationDomain);
		}
		
		//ClassType->[...] extendsCassList
		private function registComponentWithClassTypeHeritance(classType:String, rootApplicationDomain:ApplicationDomain = null):Array
		{
			var classTypeHeritanceList:Array = _classTypeHeritanceMap[classType];
			
			if(classTypeHeritanceList == null)
			{
				var cls:Class = null;
				try
				{
					if(rootApplicationDomain != null)
					{
						cls = rootApplicationDomain.getDefinition(classType) as Class;
					}
					else
					{
						cls = getDefinitionByName(classType) as Class;
					}
				}
				catch(error:Error)
				{
				}

				if(cls != null)
				{
					classTypeHeritanceList = [classType];

					//--
					
					if(classType != STYELE_ROOT_CLASS_TYPE)
					{
						var superClsType:String = getQualifiedSuperclassName(cls);
						var superClassTypeHeritanceList:Array = registComponentWithClassTypeHeritance(superClsType, rootApplicationDomain); 
						
						if(superClassTypeHeritanceList)
						{
							classTypeHeritanceList = classTypeHeritanceList.concat(superClassTypeHeritanceList);
						}
					}
				}
					
			}

			_classTypeHeritanceMap[classType] = classTypeHeritanceList;
			
			return classTypeHeritanceList;
		}
		
		private function registComponentWithClassHeritanceStyleMeataInfo(classType:String, rootApplicationDomain:ApplicationDomain = null):Object
		{
			var clsMetadataInfo:Object = _classHeritanceStyleMeataInfoMap[classType];
			
			if(clsMetadataInfo == null)
			{
				var cls:Class = null;
				try
				{
					if(rootApplicationDomain != null)
					{
						cls = rootApplicationDomain.getDefinition(classType) as Class;
					}
					else
					{
						cls = getDefinitionByName(classType) as Class;
					}
				}
				catch(error:Error)
				{
				}
				
				if(cls != null)
				{
					clsMetadataInfo = getClassStyleDefinition(cls);
					
					//--
					
					if(classType != STYELE_ROOT_CLASS_TYPE)
					{
						var superClsType:String = getQualifiedSuperclassName(cls);
						
						var superClsMetadataInfo:Object = registComponentWithClassHeritanceStyleMeataInfo(superClsType); 
						
						clsMetadataInfo = ObjectUtil.overrideOject2(clsMetadataInfo, superClsMetadataInfo);
					}
				}
			}
			
			_classHeritanceStyleMeataInfoMap[classType] = clsMetadataInfo;
			
			return clsMetadataInfo;
		}

		private function getClassStyleDefinition(cls:Class):Object
		{
			var styleDefinitions:Array = null;
			
			try
			{
				styleDefinitions = cls["getStyleDefinition"]();
			}
			catch(error:Error) {};
			
			var styleDefinitionMap:Object = {};
			
			var styleDefinitionItem:Object = null;
			for(var i:int = 0, n:int = styleDefinitions ? styleDefinitions.length : 0; i < n; i++)
			{
				styleDefinitionItem = styleDefinitions[i];
				styleDefinitionMap[styleDefinitionItem.name] = styleDefinitionItem;
			}
			
			return styleDefinitionMap;
		}
		
		private function registerInheritingStylePropByClassClsMetadataInfo(clsMetadataInfo:Object):void
		{
			var styleProp:String = null;
			for each(var styleItem:Object in clsMetadataInfo)
			{
				if(styleItem.inherit)
				{
					styleProp = styleItem.name;
					registerInheritingStyleProp(styleProp);
				}
			}
		}
		
        public function getGlobalStyleDeclaration():CSSStyleDeclaration
        {
            return getStyleDeclaration("global");
        }
		
		public function getFilteredStyleDeclaration(c:CSSStyleDeclaration, isGetInheritingStyleProp:Boolean):CSSStyleDeclaration
		{
			if(c == null) return null;
			
			var protoChain:Object = {};
			var cProtoChain:Object = c.getStyleProtoChain();
			for(var s:String in cProtoChain)
			{
				if(isGetInheritingStyleProp == isInheritingStyleProp(s))
				{
					protoChain[s] = cProtoChain[s];
				}
			}
			
			var result:CSSStyleDeclaration = new CSSStyleDeclaration(protoChain);
			return result;
		}
		
        //Self Class and All Super Class End with SkinableComponent
		//从STYELE_ROOT_CLASS_TYPE开始向当前target覆盖CSSStyleDeclaration
        public function getHeritingClassTypeListStyleDeclaration(component:SkinableComponent):CSSStyleDeclaration
        {
			var componentClassType:String = getQualifiedClassName(component);
			var classTypeHeritanceList:Array = _classTypeHeritanceMap[componentClassType];
			
			if(classTypeHeritanceList && classTypeHeritanceList.length)
			{
				var resultSelector:CSSStyleDeclaration = null;
				var classType:String = null;
				var className:String = null;
				var clsSelector:CSSStyleDeclaration = null;
				//从顶层(STYELE_ROOT_CLASS_TYPE)到当前
				//classTypesChain的最后一个必须是STYELE_ROOT_CLASS_TYPE,如果不是则不是该框架的继承结构
				var n:uint = classTypeHeritanceList.length;//must > 0;
				for(var i:int = n - 1; i >= 0; i--)
				{
					classType = classTypeHeritanceList[i];
					className = DescribeTypeUitil.getClassNameByClassType(classType);
					clsSelector = getStyleDeclaration(className);
					
					if(resultSelector == null)
					{
						resultSelector = clsSelector;
					}
					else
					{
						resultSelector.overrideStyleProps(clsSelector);
					}
				}
				
				return resultSelector;
			}
			
			return null;
        }
		
		public function getHeritingClassStyleMetadataInfos(component:SkinableComponent):Object
		{
			var componentClassType:String = getQualifiedClassName(component);
			
			return _classHeritanceStyleMeataInfoMap[componentClassType];
		}
		
		
		private function generateAndCacheTargetClassesStyleDeclaration(target:*/*instance Not Class*/):void
		{
			if(target != null || target is Class) return;
		}
        
        public function registerInheritingStyleProp(styleProp:String):void
        {
            _inheritingStylesProps[styleProp] = true;
        }
        
        public function isInheritingStyleProp(styleProp:String):Boolean
        {
            return _inheritingStylesProps[styleProp] == true;
        }
        
        //_btn Button
        public function getStyleDeclaration(selector:String):CSSStyleDeclaration
        {
            if(selector == null) return null;
            
            var c:CSSStyleDeclaration = _selectorstorCache[selector];

			return c != null ? c.clone() : null;
        }
        
        public function setStyleDeclaration(selector:String, styleDeclaration:CSSStyleDeclaration, update:Boolean):void
        {
            if(!selector) return;
            
            _selectorstorCache[selector] = styleDeclaration;
            
            if(update)
            {
                styleDeclarationsChanged();
            }
        }
        
        public function clearStyleDeclaration(selector:String, update:Boolean):void
        {
            if(!selector) return;

            delete _selectorstorCache[selector];
            
            if(update)
            {
                styleDeclarationsChanged();
            }
        }
        
        private function styleDeclarationsChanged():void
        {
			myApplication.regenerateStyleCache(true);
        }
        
        public function regenerateStylePropChian(stylePropChain:Object):void
        {
            if(stylePropChain == null) return;
            
            for(var s:String in stylePropChain)
            {
                _selectorstorCache[s] = new CSSStyleDeclaration(stylePropChain[s]);
            }
        }
		
		public function initStyleByPropChian(stylePropChainMap:Object):void
		{
			if(stylePropChainMap == null) return;

			for(var s:String in stylePropChainMap)
			{
				_selectorstorCache[s] = new CSSStyleDeclaration(stylePropChainMap[s]);
			}
		}
		
        public function loadStyleDeclarations(url:String, update:Boolean = true):IEventDispatcher
        {
//			var loader:Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
//				function loaderCompleteHandler(event:Event):void
//				{
//					
//				});
//			
//			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 
//				function loaderIOErrorHandler(event:IOErrorEvent):void
//				{
//					
//				});
//			
//			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS
//				function loaderProgressHandler(event:ProgressEvent):void
//				{
//					
//				});
//
//			return loader;
			
			return null;
        }
        
        public function unloadStyleDeclarations(url:String, update:Boolean = true):void
        {
        }
    }
}