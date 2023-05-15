import 'dart:ui';

import '../base/amap_flutter_base.dart';
import '../map/src/types/bitmap.dart';
import '../map/src/types/marker.dart';

///官方漏了flat参数，补上
class FlatMarker extends Marker {
  /// 平贴地图效果
  final bool flat;

  FlatMarker({
    this.flat = true,
    required LatLng position,
    double alpha = 1.0,
    Offset anchor = const Offset(0.5, 0.5),
    bool clickable = true,
    bool draggable = false,
    BitmapDescriptor icon = BitmapDescriptor.defaultMarker,
    bool infoWindowEnable = true,
    InfoWindow infoWindow = InfoWindow.noText,
    double rotation = 0.0,
    bool visible = true,
    double zIndex = 0.0,
    ArgumentCallback<String>? onTap,
    MarkerDragEndCallback? onDragEnd,
  }) : super(
          position: position,
          alpha: alpha,
          anchor: anchor,
          clickable: clickable,
          draggable: draggable,
          icon: icon,
          infoWindowEnable: infoWindowEnable,
          infoWindow: infoWindow,
          rotation: rotation,
          visible: visible,
          zIndex: zIndex,
          onTap: onTap,
          onDragEnd: onDragEnd,
        );

  /// copy的真正复制的参数，主要用于需要修改某个属性参数时使用
  @override
  FlatMarker copyWith({
    double? alphaParam,
    Offset? anchorParam,
    bool? clickableParam,
    bool? flatParam,
    bool? draggableParam,
    BitmapDescriptor? iconParam,
    bool? infoWindowEnableParam,
    InfoWindow? infoWindowParam,
    LatLng? positionParam,
    double? rotationParam,
    bool? visibleParam,
    ArgumentCallback<String?>? onTapParam,
    MarkerDragEndCallback? onDragEndParam,
  }) {
    FlatMarker copyMark = FlatMarker(
      alpha: alphaParam ?? alpha,
      anchor: anchorParam ?? anchor,
      clickable: clickableParam ?? clickable,
      flat: flatParam ?? flat,
      draggable: draggableParam ?? draggable,
      icon: iconParam ?? icon,
      infoWindowEnable: infoWindowEnableParam ?? infoWindowEnable,
      infoWindow: infoWindowParam ?? infoWindow,
      position: positionParam ?? position,
      rotation: rotationParam ?? rotation,
      visible: visibleParam ?? visible,
      zIndex: zIndex,
      onTap: onTapParam ?? onTap,
      onDragEnd: onDragEndParam ?? onDragEnd,
    );
    copyMark.setIdForCopy(id);
    return copyMark;
  }

  @override
  Marker clone() => copyWith();

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> json = <String, dynamic>{};
    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('id', id);
    addIfPresent('alpha', alpha);
    addIfPresent('anchor', _offsetToJson(anchor));
    addIfPresent('clickable', clickable);
    addIfPresent('flat', flat);
    addIfPresent('draggable', draggable);
    addIfPresent('icon', icon.toMap());
    addIfPresent('infoWindowEnable', infoWindowEnable);
    addIfPresent('infoWindow', _infoWindowToJson(infoWindow));
    addIfPresent('position', position.toJson());
    addIfPresent('rotation', rotation);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    return json;
  }

  @override
  int get hashCode => super.hashCode+0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! FlatMarker) return false;
    final FlatMarker typedOther = other;
    return id == typedOther.id &&
        alpha == typedOther.alpha &&
        anchor == typedOther.anchor &&
        clickable == typedOther.clickable &&
        flat == typedOther.flat &&
        draggable == typedOther.draggable &&
        icon == typedOther.icon &&
        infoWindowEnable == typedOther.infoWindowEnable &&
        infoWindow == typedOther.infoWindow &&
        position == typedOther.position &&
        rotation == typedOther.rotation &&
        visible == typedOther.visible &&
        zIndex == typedOther.zIndex;
  }

  dynamic _offsetToJson(Offset offset) {
    return <dynamic>[offset.dx, offset.dy];
  }

  dynamic _infoWindowToJson(infoWindow) {
    final Map<String, dynamic> json = <String, dynamic>{};
    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('title', infoWindow.title);
    addIfPresent('snippet', infoWindow.snippet);
    return json;
  }


  @override
  String toString() {
    return 'Marker{id: $id, alpha: $alpha, anchor: $anchor, '
        'clickable: $clickable,flat: $flat, draggable: $draggable,'
        'icon: $icon, infoWindowEnable: $infoWindowEnable, infoWindow: $infoWindow, position: $position, rotation: $rotation, '
        'visible: $visible, zIndex: $zIndex, onTap: $onTap}';
  }


}
