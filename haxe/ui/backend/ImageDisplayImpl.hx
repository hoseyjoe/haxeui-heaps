package haxe.ui.backend;
import haxe.ui.Toolkit;

class ImageDisplayImpl extends ImageBase {
    public var sprite:h2d.Bitmap;

    public function new() {
        super();
        sprite = new h2d.Bitmap();
    }

    /** The image has more pixels than it measures (a `name@4x.png`, see AssetsImpl): always scaled down. */
    private var _hiRes:Bool = false;

    private override function validateData() {
        if (_imageInfo != null) {
            var bmp = _imageInfo.data;
            _hiRes = bmp.width > _imageInfo.width;
            if (_hiRes) {
                // Mipmapped, so however far it is scaled down it is filtered from a level near the
                // size it is drawn at, rather than sampling a few of its pixels and aliasing.
                var tex = new h3d.mat.Texture(bmp.width, bmp.height, [MipMapped]);
                tex.uploadBitmap(bmp);
                tex.mipMap = Linear;
                sprite.tile = h2d.Tile.fromTexture(tex);
            } else {
                sprite.tile = h2d.Tile.fromBitmap(bmp);
            }
        } else {
            sprite.tile.dispose();
            sprite.tile = null;
        }
    }

    private override function validatePosition() {
        if (sprite.x != _left) {
            sprite.x = _left;
        }

        if (sprite.y != _top) {
            sprite.y = _top;
        }
    }

    private override function validateDisplay() {
        if (sprite.tile != null) {
            var scaleX:Float = (_imageWidth / sprite.tile.width);
            if (sprite.scaleX != scaleX) {
                sprite.scaleX = scaleX;
            }

            var scaleY:Float = (_imageHeight / sprite.tile.height);
            if (sprite.scaleY != scaleY) {
                sprite.scaleY = scaleY;
            }

            // A plain image stays pixel-exact; a high-resolution one is filtered down to its size.
            sprite.smooth = _hiRes;
        }
    }
    
    public override function dispose() {
        if (sprite.tile != null) {
            sprite.tile.dispose();
            sprite.tile = null;
        }
    }
}