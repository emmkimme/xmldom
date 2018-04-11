# THIS VERSION IS A FORK OF [xmldom](https://github.com/jindw/xmldom)
## Purpose was to fix several pending issues. It has been integrated in a uniq package covering xml and xpath :
## See [common-xml-features](https://www.npmjs.com/package/common-xml-features)

# Fixes
## Serializer - bug
- Do not encode '>' !!!

dom.js
```
--- a/dom.js
+++ b/dom.js
@@ -1051,9 +1051,9 @@ function serializeToString(node,buf,isHTML,nodeFilter,visibleNamespaces){
 		}
 		return;
 	case ATTRIBUTE_NODE:
-		return buf.push(' ',node.name,'="',node.value.replace(/[<&"]/g,_xmlEncoder),'"');
+		return buf.push(' ',node.name,'="',node.value.replace(/[<>&"]/g,_xmlEncoder),'"');
 	case TEXT_NODE:
-		return buf.push(node.data.replace(/[<&]/g,_xmlEncoder));
+		return buf.push(node.data.replace(/[<>&]/g,_xmlEncoder));
 	case CDATA_SECTION_NODE:
 		return buf.push( '<![CDATA[',node.data,']]>');
 	case COMMENT_NODE:

```

## Parser - optim
- Stop to append an empty string to the text content on a new node, use directly the text if possible

```
--- a/dom.js
+++ b/dom.js
@@ -724,7 +724,10 @@ Element.prototype = {
 	},
 	setAttribute : function(name, value){
 		var attr = this.ownerDocument.createAttribute(name);
-		attr.value = attr.nodeValue = "" + value;
+		if (typeof value !== 'string') {
+			value = "" + value;
+		}
+		attr.value = attr.nodeValue = value;
 		this.setAttributeNode(attr)
 	},
 	removeAttribute : function(name){
@@ -765,7 +768,10 @@ Element.prototype = {
 	},
 	setAttributeNS : function(namespaceURI, qualifiedName, value){
 		var attr = this.ownerDocument.createAttributeNS(namespaceURI, qualifiedName);
-		attr.value = attr.nodeValue = "" + value;
+		if (typeof value !== 'string') {
+			value = "" + value;
+		}
+		attr.value = attr.nodeValue = value;
 		this.setAttributeNode(attr)
 	},
 	getAttributeNodeNS : function(namespaceURI, localName){
@@ -815,9 +821,11 @@ CharacterData.prototype = {
 		return this.data.substring(offset, offset+count);
 	},
 	appendData: function(text) {
-		text = this.data+text;
+		if (this.data) {
+			text = this.data + text;
+		}
 		this.nodeValue = this.data = text;
-		this.length = text.length;
+		this.length = this.data.length;
 	},
 	insertData: function(offset,text) {
 		this.replaceData(offset,0,text);

```