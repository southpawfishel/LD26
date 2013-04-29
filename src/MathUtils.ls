package
{
    import Loom.Graphics.Point2;
    
    class MathUtils
    {
        public static function subtractPoint(p1:Point2, p2:Point2):Point2
        {
            var ret:Point2 = new Point2();
            ret.x = p1.x - p2.x;
            ret.y = p1.y - p2.y;
            return ret;
        }
    
        public static function scalePoint(point:Point2, scalar:Number):Point2
        {
            var ret:Point2 = new Point2();
            ret.x = point.x * scalar;
            ret.y = point.y * scalar;
            return ret;
        }
        
        public static function randomInRange(min:int, max:int):int
        {
            return Math.floor(min + (Math.random() * (max - min)));
        }
        
        public static function randomSign():int
        {
            return Math.random() < 0.5 ? -1 : 1;
        }
        
        public static function randomPoint(minX:Number, minY:Number, maxX:Number, maxY:Number):Point2
        {
            var ret:Point2 = new Point2();
            ret.x = randomInRange(minX, maxX);
            ret.y = randomInRange(minY, maxY);
            return ret;
        }
    }
}