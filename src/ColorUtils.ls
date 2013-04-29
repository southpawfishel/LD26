package
{
    import cocos2d.ccColor3B;

    public class ColorUtils
    {
        public static function intToRGB(value:int):ccColor3B
        {
            var r = (value >> 16) & 0xFF;
            var g = (value >> 8) & 0xFF;
            var b = value & 0xFF;
        
            return new ccColor3B(r,g,b);
        }
    }
}