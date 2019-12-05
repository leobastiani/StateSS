
import java.awt.image.BufferedImage;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Leonardo
 */
public class Pixel {

    XY xy;
    int r;
    int g;
    int b;

    public Pixel(int x, int y, BufferedImage image) {
        this.xy = new XY(x, y);
        byte[] rgb = AnalisadorImg.intToRgb(image.getRGB(x, y));
        setR(unsigned(rgb[0]));
        setG(unsigned(rgb[1]));
        setB(unsigned(rgb[2]));
    }

    public int getB() {
        return b;
    }

    public void setB(int b) {
        this.b = b;
    }

    public int getG() {
        return g;
    }

    public void setG(int g) {
        this.g = g;
    }

    public int getR() {
        return r;
    }

    public void setR(int r) {
        this.r = r;
    }

    public XY getXy() {
        return xy;
    }

    public void setXy(XY xy) {
        this.xy = xy;
    }

    @Override
    public String toString() {
        return xy.getX() + ", " + xy.getY() + ": " + (r) + ", " + (g) + ", " + (b);
    }

    private static int unsigned(byte b) {
        return (int) (b < 0 ? 256 + b : b);
    }

}
