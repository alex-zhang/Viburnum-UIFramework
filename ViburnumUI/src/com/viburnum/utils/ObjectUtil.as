package com.viburnum.utils
{
    import com.viburnum.data.IList;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import flash.xml.XMLNode;
    
    public final class ObjectUtil
    {
        private static var defaultToStringExcludes:Array = ["password", "credentials"];
        
        private static var refCount:int = 0;
        private static var CLASS_INFO_CACHE:Object = {};
        
        public static function compare(a:Object, b:Object, depth:int = -1):int
        {
            return internalCompare(a, b, 0, depth, new Dictionary(true));
        }
        
        public static function copy(value:Object):Object
        {
            var buffer:ByteArray = new ByteArray();
            buffer.writeObject(value);
            buffer.position = 0;
            var result:Object = buffer.readObject();
            return result;
        }
        
        public static function clone(value:Object):Object
        {
            var result:Object = copy(value);
            cloneInternal(result, value);
            return result;
        }
		
        private static function cloneInternal(result:Object, value:Object):void
        {
            result.uid = value.uid;
            var classInfo:Object = getClassInfo(value);
            var v:Object;
            for each (var p:* in classInfo.properties) 
            {
                v = value[p];
                if (v && v.hasOwnProperty("uid")) 
                    cloneInternal(result[p], v);
            }
        }

        public static function isSimple(value:Object):Boolean
        {
            var type:String = typeof(value);
            switch (type)
            {
                case "number":
                case "string":
                case "boolean":
                {
                    return true;
                }
                    
                case "object":
                {
                    return (value is Date) || (value is Array);
                }
            }
            
            return false;
        }
        
        public static function numericCompare(a:Number, b:Number):int
        {
            if (isNaN(a) && isNaN(b))
                return 0;
            
            if (isNaN(a))
                return 1;
            
            if (isNaN(b))
                return -1;
            
            if (a < b)
                return -1;
            
            if (a > b)
                return 1;
            
            return 0;
        }
        
        public static function stringCompare(a:String, b:String,
                                             caseInsensitive:Boolean = false):int
        {
            if (a == null && b == null)
                return 0;
            
            if (a == null)
                return 1;
            
            if (b == null)
                return -1;
            
            // Convert to lowercase if we are case insensitive.
            if (caseInsensitive)
            {
                a = a.toLocaleLowerCase();
                b = b.toLocaleLowerCase();
            }
            
            var result:int = a.localeCompare(b);
            
            if (result < -1)
                result = -1;
            else if (result > 1)
                result = 1;
            
            return result;
        }
        
        public static function dateCompare(a:Date, b:Date):int
        {
            if (a == null && b == null)
                return 0;
            
            if (a == null)
                return 1;
            
            if (b == null)
                return -1;
            
            var na:Number = a.getTime();
            var nb:Number = b.getTime();
            
            if (na < nb)
                return -1;
            
            if (na > nb)
                return 1;
            
            return 0;
        }
        
        public static function toString(value:Object, 
                                        namespaceURIs:Array = null, 
                                        exclude:Array = null):String
        {
            if (exclude == null)
            {
                exclude = defaultToStringExcludes;
            }
            
            refCount = 0;
            return internalToString(value, 0, null, namespaceURIs, exclude);
        }
        
        private static function internalToString(value:Object, 
                                                 indent:int = 0,
                                                 refs:Dictionary= null, 
                                                 namespaceURIs:Array = null, 
                                                 exclude:Array = null):String
        {
            var str:String;
            var type:String = value == null ? "null" : typeof(value);
            switch (type)
            {
                case "boolean":
                case "number":
                {
                    return value.toString();
                }
                    
                case "string":
                {
                    return "\"" + value.toString() + "\"";
                }
                    
                case "object":
                {
                    if (value is Date)
                    {
                        return value.toString();
                    }
                    else if (value is XMLNode)
                    {
                        return value.toString();
                    }
                    else if (value is Class)
                    {
                        return "(" + getQualifiedClassName(value) + ")";
                    }
                    else
                    {
                        var classInfo:Object = getClassInfo(value, exclude,
                            { includeReadOnly: true, uris: namespaceURIs });
                        
                        var properties:Array = classInfo.properties;
                        
                        str = "(" + classInfo.name + ")";
                        
                        // refs help us avoid circular reference infinite recursion.
                        // Each time an object is encoumtered it is pushed onto the
                        // refs stack so that we can determine if we have visited
                        // this object already.
                        if (refs == null)
                            refs = new Dictionary(true);
                        
                        // Check to be sure we haven't processed this object before
                        // Dictionary has some bugs, so we want to work around them as best we can
                        try
                        {
                            var id:Object = refs[value];
                            if (id != null)
                            {
                                str += "#" + int(id);
                                return str;
                            }
                        }
                        catch (e:Error)
                        {
                            //Since we can't test for infinite loop, we simply return toString.
                            return String(value);
                        }
                        
                        if (value != null)
                        {
                            str += "#" + refCount.toString();
                            refs[value] = refCount;
                            refCount++;
                        }
                        
                        var isArray:Boolean = value is Array;
                        var isDict:Boolean = value is Dictionary;
                        var prop:*;
                        indent += 2;
                        
                        // Print all of the variable values.
                        for (var j:int = 0; j < properties.length; j++)
                        {
                            str = newline(str, indent);
                            prop = properties[j];
                            
                            if (isArray)
                                str += "[";
                            else if (isDict)
                                str += "{";
                            
                            
                            if (isDict)
                            {
                                // in dictionaries, recurse on the key, because it can be a complex object
                                str += internalToString(prop, indent, refs,
                                    namespaceURIs, exclude);
                            }
                            else
                            {
                                str += prop.toString();
                            }
                            
                            if (isArray)
                                str += "] ";
                            else if (isDict)
                                str += "} = ";
                            else
                                str += " = ";
                            
                            try
                            {
                                // print the value
                                str += internalToString(value[prop], indent, refs,
                                    namespaceURIs, exclude);
                            }
                            catch(e:Error)
                            {
                                // value[prop] can cause an RTE
                                // for certain properties of certain objects.
                                // For example, accessing the properties
                                //   actionScriptVersion
                                //   childAllowsParent
                                //   frameRate
                                //   height
                                //   loader
                                //   parentAllowsChild
                                //   sameDomain
                                //   swfVersion
                                //   width
                                // of a Stage's loaderInfo causes
                                //   Error #2099: The loading object is not
                                //   sufficiently loaded to provide this information
                                // In this case, we simply output ? for the value.
                                str += "?";
                            }
                        }
                        indent -= 2;
                        return str;
                    }
                    break;
                }
                    
                case "xml":
                {
                    return value.toXMLString();
                }
                    
                default:
                {
                    return "(" + type + ")";
                }
            }
            
            return "(unknown)";
        }
        
        private static function newline(str:String, n:int = 0):String
        {
            var result:String = str;
            result += "\n";
            
            for (var i:int = 0; i < n; i++)
            {
                result += " ";
            }
            return result;
        }
        
        private static function internalCompare(a:Object, b:Object,
                                                currentDepth:int, desiredDepth:int,
                                                refs:Dictionary):int
        {
            if (a == null && b == null)
                return 0;
            
            if (a == null)
                return 1;
            
            if (b == null)
                return -1;
            
            var typeOfA:String = typeof(a);
            var typeOfB:String = typeof(b);
            
            var result:int = 0;
            
            if (typeOfA == typeOfB)
            {
                switch(typeOfA)
                {
                    case "boolean":
                    {
                        result = numericCompare(Number(a), Number(b));
                        break;
                    }
                        
                    case "number":
                    {
                        result = numericCompare(a as Number, b as Number);
                        break;
                    }
                        
                    case "string":
                    {
                        result = stringCompare(a as String, b as String);
                        break;
                    }
                        
                    case "object":
                    {
                        var newDepth:int = desiredDepth > 0 ? desiredDepth -1 : desiredDepth;
                        
                        // refs help us avoid circular reference infinite recursion.
                        var aRef:Object = getRef(a,refs);
                        var bRef:Object = getRef(b,refs);
                        
                        if (aRef == bRef)
                            return 0;
                        // the cool thing about our dictionary is that if 
                        // we've seen objects and determined that they are inequal, then 
                        // we would've already exited out of this compare() call.  So the 
                        // only info in the dictionary are sets of equal items
                        
                        // let's first define them as equal
                        // this stops an "infinite loop" problem where A.i = B and B.i = A
                        // if we later find that an object (one of the subobjects) is in fact unequal, 
                        // then we will return false and quit out of everything.  These refs are thrown away
                        // so it doesn't matter if it's correct.
                        refs[bRef] = aRef;
                        
                        if (desiredDepth != -1 && (currentDepth > desiredDepth))
                        {
                            // once we try to go beyond the desired depth we should 
                            // toString() our way out
                            result = stringCompare(a.toString(), b.toString());
                        }
                        else if ((a is Array) && (b is Array))
                        {
                            result = arrayCompare(a as Array, b as Array, currentDepth, desiredDepth, refs);
                        }
                        else if ((a is Date) && (b is Date))
                        {
                            result = dateCompare(a as Date, b as Date);
                        }
                        else if ((a is IList) && (b is IList))
                        {
                            result = listCompare(a as IList, b as IList, currentDepth, desiredDepth, refs);
                        }
                        else if ((a is ByteArray) && (b is ByteArray))
                        {
                            result = byteArrayCompare(a as ByteArray, b as ByteArray);
                        }
                        else if (getQualifiedClassName(a) == getQualifiedClassName(b))
                        {
                            var aProps:Array = getClassInfo(a).properties;
                            var bProps:Array;
                            
                            // if the objects are dynamic they could have different 
                            // # of properties and should be treated on that basis first
                            var isDynamicObject:Boolean = isDynamicObject(a);
                            
                            // if it's dynamic, check to see that they have all the same properties
                            if (isDynamicObject)
                            {
                                bProps = getClassInfo(b).properties;
                                result = arrayCompare(aProps, bProps, currentDepth, newDepth, refs);
                                if (result != 0)
                                    return result;
                            }
                            
                            // now that we know we have the same properties, let's compare the values
                            var propName:QName;
                            var aProp:Object;
                            var bProp:Object;
                            for (var i:int = 0; i < aProps.length; i++)
                            {
                                propName = aProps[i];
                                aProp = a[propName];
                                bProp = b[propName];
                                result = internalCompare(aProp, bProp, currentDepth+1, newDepth, refs);
                                if (result != 0)
                                {
                                    return result;
                                }
                            }
                        }
                        else
                        {
                            // We must be inequal, so return 1
                            return 1;
                        }
                        break;
                    }
                }
            }
            else // be consistent with the order we return here
            {
                return stringCompare(typeOfA, typeOfB);
            }
            
            return result;
        }
        
        public static function getClassInfo(obj:Object,
                                            excludes:Array = null,
                                            options:Object = null):Object
        {   
            var n:int;
            var i:int;
            
            if (options == null)
                options = { includeReadOnly: true, uris: null, includeTransient: true };
            
            var result:Object;
            var propertyNames:Array = [];
            var cacheKey:String;
            
            var className:String;
            var classAlias:String;
            var properties:XMLList;
            var prop:XML;
            var dynamic:Boolean = false;
            var metadataInfo:Object;
            
            if (typeof(obj) == "xml")
            {
                className = "XML";
                properties = obj.text();
                if (properties.length())
                    propertyNames.push("*");
                properties = obj.attributes();
            }
            else
            {
                var classInfo:XML = flash.utils.describeType(obj);
                className = classInfo.@name.toString();
                classAlias = classInfo.@alias.toString();
                dynamic = (classInfo.@isDynamic.toString() == "true");
                
                if (options.includeReadOnly)
                    properties = classInfo..accessor.(@access != "writeonly") + classInfo..variable;
                else
                    properties = classInfo..accessor.(@access == "readwrite") + classInfo..variable;
                
                var numericIndex:Boolean = false;
            }
            
            // If type is not dynamic, check our cache for class info...
            if (!dynamic)
            {
                cacheKey = getCacheKey(obj, excludes, options);
                result = CLASS_INFO_CACHE[cacheKey];
                if (result != null)
                    return result;
            }
            
            result = {};
            result["name"] = className;
            result["alias"] = classAlias;
            result["properties"] = propertyNames;
            result["dynamic"] = dynamic;
            result["metadata"] = metadataInfo = recordMetadata(properties);
            
            var excludeObject:Object = {};
            if (excludes)
            {
                n = excludes.length;
                for (i = 0; i < n; i++)
                {
                    excludeObject[excludes[i]] = 1;
                }
            }
            
            // TODO (pfarland): this seems slightly fragile, why not use the 'is' operator?
            var isArray:Boolean = (className == "Array");
            var isDict:Boolean  = (className == "flash.utils::Dictionary");
            
            if (isDict)
            {
                // dictionaries can have multiple keys of the same type,
                // (they can index by reference rather than QName, String, or number),
                // which cannot be looked up by QName, so use references to the actual key
                for (var key:* in obj)
                {
                    propertyNames.push(key);
                }
            }
            else if (dynamic)
            {
                for (var p:String in obj)
                {
                    if (excludeObject[p] != 1)
                    {
                        if (isArray)
                        {
                            var pi:Number = parseInt(p);
                            if (isNaN(pi))
                                propertyNames.push(new QName("", p));
                            else
                                propertyNames.push(pi);
                        }
                        else
                        {
                            propertyNames.push(new QName("", p));
                        }
                    }
                }
                numericIndex = isArray && !isNaN(Number(p));
            }
            
            if (isArray || isDict || className == "Object")
            {
                // Do nothing since we've already got the dynamic members
            }
            else if (className == "XML")
            {
                n = properties.length();
                for (i = 0; i < n; i++)
                {
                    p = properties[i].name();
                    if (excludeObject[p] != 1)
                        propertyNames.push(new QName("", "@" + p));
                }
            }
            else
            {
                n = properties.length();
                var uris:Array = options.uris;
                var uri:String;
                var qName:QName;
                for (i = 0; i < n; i++)
                {
                    prop = properties[i];
                    p = prop.@name.toString();
                    uri = prop.@uri.toString();
                    
                    if (excludeObject[p] == 1)
                        continue;
                    
                    if (!options.includeTransient && internalHasMetadata(metadataInfo, p, "Transient"))
                        continue;
                    
                    if (uris != null)
                    {
                        if (uris.length == 1 && uris[0] == "*")
                        {   
                            qName = new QName(uri, p);
                            try
                            {
                                obj[qName]; // access the property to ensure it is supported
                                propertyNames.push();
                            }
                            catch(e:Error)
                            {
                                // don't keep property name 
                            }
                        }
                        else
                        {
                            for (var j:int = 0; j < uris.length; j++)
                            {
                                uri = uris[j];
                                if (prop.@uri.toString() == uri)
                                {
                                    qName = new QName(uri, p);
                                    try
                                    {
                                        obj[qName];
                                        propertyNames.push(qName);
                                    }
                                    catch(e:Error)
                                    {
                                        // don't keep property name 
                                    }
                                }
                            }
                        }
                    }
                    else if (uri.length == 0)
                    {
                        qName = new QName(uri, p);
                        try
                        {
                            obj[qName];
                            propertyNames.push(qName);
                        }
                        catch(e:Error)
                        {
                            // don't keep property name 
                        }
                    }
                }
            }
            
            propertyNames.sort(Array.CASEINSENSITIVE |
                (numericIndex ? Array.NUMERIC : 0));
            
            // dictionary keys can be indexed by an object reference
            // there's a possibility that two keys will have the same toString()
            // so we don't want to remove dupes
            if (!isDict)
            {
                // for Arrays, etc., on the other hand...
                // remove any duplicates, i.e. any items that can't be distingushed by toString()
                for (i = 0; i < propertyNames.length - 1; i++)
                {
                    // the list is sorted so any duplicates should be adjacent
                    // two properties are only equal if both the uri and local name are identical
                    if (propertyNames[i].toString() == propertyNames[i + 1].toString())
                    {
                        propertyNames.splice(i, 1);
                        i--; // back up
                    }
                }
            }
            
            // For normal, non-dynamic classes we cache the class info
            if (!dynamic)
            {
                cacheKey = getCacheKey(obj, excludes, options);
                CLASS_INFO_CACHE[cacheKey] = result;
            }
            
            return result;
        }
        
        
        public static function hasMetadata(obj:Object, 
                                           propName:String, 
                                           metadataName:String, 
                                           excludes:Array = null,
                                           options:Object = null):Boolean
        {
            var classInfo:Object = getClassInfo(obj, excludes, options);
            var metadataInfo:Object = classInfo["metadata"];
            return internalHasMetadata(metadataInfo, propName, metadataName);
        }
        
        public static function isDynamicObject(obj:Object):Boolean
        {
            try
            {
                // this test for checking whether an object is dynamic or not is 
                // pretty hacky, but it assumes that no-one actually has a 
                // property defined called "wootHackwoot"
                obj["wootHackwoot"];
            }
            catch (e:Error)
            {
                // our object isn't from a dynamic class
                return false;
            }
            return true;
        }
		
		//simple Clone
		public static function clone2(value:Object):Object
		{
			var resut:Object = {};
			if(value == null) return resut;
			
			for(var s:String in value)
			{
				resut[s] = value[s];
			}
			
			return resut;
		}
		
		//override object
		public static function overrideOject2(childObejct:Object, parentObject:Object):Object
		{
			var parentObjectClone:Object = clone2(parentObject);
			for(var p:String in childObejct)
			{
				parentObjectClone[p] = childObejct[p];
			}
			
			return parentObjectClone;
		}
        
        private static function internalHasMetadata(metadataInfo:Object, propName:String, metadataName:String):Boolean
        {
            if (metadataInfo != null)
            {
                var metadata:Object = metadataInfo[propName];
                if (metadata != null)
                {
                    if (metadata[metadataName] != null)
                        return true;
                }
            }
            return false;
        }
        
        private static function recordMetadata(properties:XMLList):Object
        {
            var result:Object = null;
            
            try
            {
                for each (var prop:XML in properties)
                {
                    var propName:String = prop.attribute("name").toString();
                    var metadataList:XMLList = prop.metadata;
                    
                    if (metadataList.length() > 0)
                    {
                        if (result == null)
                            result = {};
                        
                        var metadata:Object = {};
                        result[propName] = metadata;
                        
                        for each (var md:XML in metadataList)
                        {
                            var mdName:String = md.attribute("name").toString();
                            
                            var argsList:XMLList = md.arg;
                            var value:Object = {};
                            
                            for each (var arg:XML in argsList)
                            {
                                var argKey:String = arg.attribute("key").toString();
                                if (argKey != null)
                                {
                                    var argValue:String = arg.attribute("value").toString();
                                    value[argKey] = argValue;
                                }
                            }
                            
                            var existing:Object = metadata[mdName];
                            if (existing != null)
                            {
                                var existingArray:Array;
                                if (existing is Array)
                                    existingArray = existing as Array;
                                else
                                {
                                    existingArray = [existing];
                                    delete metadata[mdName];
                                }
                                existingArray.push(value);
                                existing = existingArray;
                            }
                            else
                            {
                                existing = value;
                            }
                            metadata[mdName] = existing;
                        }
                    }
                }
            }
            catch(e:Error)
            {
            }
            
            return result;
        }
        
        private static function getCacheKey(o:Object, excludes:Array = null, options:Object = null):String
        {
            var key:String = getQualifiedClassName(o);
            
            if (excludes != null)
            {
                for (var i:uint = 0; i < excludes.length; i++)
                {
                    var excl:String = excludes[i] as String;
                    if (excl != null)
                        key += excl;
                }
            }
            
            if (options != null)
            {
                for (var flag:String in options)
                {
                    key += flag;
                    var value:String = options[flag] as String;
                    if (value != null)
                        key += value;
                }
            }
            return key;
        }
        
        private static function arrayCompare(a:Array, b:Array,
                                             currentDepth:int, desiredDepth:int,
                                             refs:Dictionary):int
        {
            var result:int = 0;
            
            if (a.length != b.length)
            {
                if (a.length < b.length)
                    result = -1;
                else
                    result = 1;
            }
            else
            {
                var key:Object;
                for (key in a)
                {
                    if (b.hasOwnProperty(key))
                    {
                        result = internalCompare(a[key], b[key], currentDepth,
                            desiredDepth, refs);
                        
                        if (result != 0)
                            return result;
                    }
                    else
                    {
                        return -1;
                    }
                }
                
                for (key in b)
                {
                    if (!a.hasOwnProperty(key))
                    {
                        return 1;
                    }
                }
            }
            
            return result;
        }
        
        private static function byteArrayCompare(a:ByteArray, b:ByteArray):int
        {
            var result:int = 0;
            
            if (a == b)
                return result;
            
            if (a.length != b.length)
            {
                if (a.length < b.length)
                    result = -1;
                else
                    result = 1;
            }
            else
            {
                for (var i:int = 0; i < a.length; i++)
                {
                    result = numericCompare(a[i], b[i]);
                    if (result != 0)
                    {
                        i = a.length;
                    }
                }
            }
            return result;
        }
        
        private static function listCompare(a:IList, b:IList, currentDepth:int, 
                                            desiredDepth:int, refs:Dictionary):int
        {
            var result:int = 0;
            
            if (a.length != b.length)
            {
                if (a.length < b.length)
                    result = -1;
                else
                    result = 1;
            }
            else
            {
                for (var i:int = 0; i < a.length; i++)
                {
                    result = internalCompare(a.getItemAt(i), b.getItemAt(i), 
                        currentDepth+1, desiredDepth, refs);
                    if (result != 0)
                    {
                        i = a.length;
                    }
                }
            }
            
            return result;
        }
        
        private static function getRef(o:Object, refs:Dictionary):Object
        {
            var oRef:Object = refs[o]; 
            while (oRef && oRef != refs[oRef])
            {
                oRef = refs[oRef];
            }
            if (!oRef)
                oRef = o;
            if (oRef != refs[o])
                refs[o] = oRef;
            
            return oRef
        }
    }
}
