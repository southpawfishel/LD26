package
{
    import Loom.Graphics.Point2;
    
    class MathUtils
    {
        public static function scalePoint(point:Point2, scalar:Number):Point2
        {
            var ret:Point2 = new Point2();
            ret.x = point.x * scalar;
            ret.y = point.y * scalar;
            return ret;
        }
    }
}