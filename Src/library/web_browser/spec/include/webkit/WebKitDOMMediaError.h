/*
    This file is part of the WebKit open source project.
    This file has been generated by generate-bindings.pl. DO NOT MODIFY!

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public License
    along with this library; see the file COPYING.LIB.  If not, write to
    the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA 02110-1301, USA.
*/

#ifndef WebKitDOMMediaError_h
#define WebKitDOMMediaError_h

#include "webkit/webkitdomdefines.h"
#include <glib-object.h>
#include <webkit/webkitdefines.h>
#include "webkit/WebKitDOMObject.h"


G_BEGIN_DECLS
#define WEBKIT_TYPE_DOM_MEDIA_ERROR            (webkit_dom_media_error_get_type())
#define WEBKIT_DOM_MEDIA_ERROR(obj)            (G_TYPE_CHECK_INSTANCE_CAST((obj), WEBKIT_TYPE_DOM_MEDIA_ERROR, WebKitDOMMediaError))
#define WEBKIT_DOM_MEDIA_ERROR_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST((klass),  WEBKIT_TYPE_DOM_MEDIA_ERROR, WebKitDOMMediaErrorClass)
#define WEBKIT_DOM_IS_MEDIA_ERROR(obj)         (G_TYPE_CHECK_INSTANCE_TYPE((obj), WEBKIT_TYPE_DOM_MEDIA_ERROR))
#define WEBKIT_DOM_IS_MEDIA_ERROR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass),  WEBKIT_TYPE_DOM_MEDIA_ERROR))
#define WEBKIT_DOM_MEDIA_ERROR_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS((obj),  WEBKIT_TYPE_DOM_MEDIA_ERROR, WebKitDOMMediaErrorClass))

struct _WebKitDOMMediaError {
    WebKitDOMObject parent_instance;
};

struct _WebKitDOMMediaErrorClass {
    WebKitDOMObjectClass parent_class;
};

WEBKIT_API GType
webkit_dom_media_error_get_type (void);

/**
 * webkit_dom_media_error_get_code:
 * @self: A #WebKitDOMMediaError
 *
 * Returns:
 *
**/
WEBKIT_API gushort
webkit_dom_media_error_get_code(WebKitDOMMediaError* self);

G_END_DECLS

#endif /* WebKitDOMMediaError_h */
