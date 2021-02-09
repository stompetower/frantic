using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;

namespace FranticMapMaker
{
    public partial class Form1 : Form
    {
        private string _path = null;
        private Bitmap _jobImg;
        private Bitmap _tilesImg = null;
        private byte[] _levelData = null;
        private int _x, _y;

        private int[] _limits = { 528,744,   // job 1
                                  648, 754, // job 2
                                  1000,1000,1000,1000,1000,1000, // job 3,4,5
                                  54,1000             // job 6
                    };

        private int _limit1, _limit2;
         

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            _path = AppDomain.CurrentDomain.BaseDirectory;

        }

        private void makeMapButton_Click(object sender, EventArgs e)
        {
            int jobNr = Convert.ToInt32(franticJobUpDown.Value);
            bool neutralizeBG = isNeutralBG.Checked;

            _tilesImg = new Bitmap(Path.Combine(_path, "frantic.png"), false);

            if (neutralizeBG) NeutralizeBG();

            _limit1 = _limits[(jobNr - 1) * 2];
            _limit2 = _limits[(jobNr - 1) * 2 + 1];

            string file = Path.Combine(_path, String.Format("FRANTIC{0}.JOB", jobNr));
            
            _levelData = File.ReadAllBytes(file);
            
            CreateNewBitmap(jobNr);
            PutTiles(jobNr);
            file = Path.Combine(_path, String.Format("Frantic_Job{0}.png", jobNr) );
            _jobImg.Save(file);
            _jobImg.Dispose();
            _tilesImg.Dispose();

            MessageBox.Show("Frantic map created: \r\n" + file);
        }

        private void NeutralizeBG()
        {
            Graphics g = Graphics.FromImage(_tilesImg);
            Brush b1 = new SolidBrush(Color.FromArgb(150, 40, 40, 40));
            Brush b2 = new SolidBrush(Color.FromArgb(150, 25, 25, 25));
            for (int y = 0; y < 1152; y += 192)
            {
                g.FillRectangle(b2, new Rectangle(128, y, 128, 16));

                g.FillRectangle(b1, new Rectangle(0, y, 128, 32));
                g.FillRectangle(b1, new Rectangle(128, y + 16, 128, 16));
                g.FillRectangle(b1, new Rectangle(384, y + 32, 128, 32));
                g.FillRectangle(b1, new Rectangle(0, y + 96, 128, 32));
                g.FillRectangle(b1, new Rectangle(0, y + 64, 512, 32));
            }
            // Clean up
            g.Dispose();

        }

        private void CreateNewBitmap(int jobNr)
        {
            if (jobNr==6)
                _jobImg = new Bitmap(512, 2176);
            else
                _jobImg = new Bitmap(1536+64, 8192 + 128);
        }

        private void PutTiles(int jobNr)
        {

            Graphics g = Graphics.FromImage(_jobImg);

            for (int row=0; row<768; row++)
            {
                for (int i=0; i<16; i++)
                {
                    _x = i;
                    _y = row;
                    int b = _levelData[row * 16 + i + 7];
                    int bg = (i % 2) + (row % 2) * 2;
                    if (b == 0x9c)                // elevator left
                        DrawBlock(g, 11, jobNr);
                    else if (b >= 0x80 && b <= 0x81)           // platform
                        DrawBlock(g, b - 112, jobNr);
                    else if (b == 0x82)           // platform
                        DrawBlock(g, 16 + 3, jobNr);
                    else if (b == 0x83)           // platform
                        DrawBlock(g, 16 + 2, jobNr);
                    else if (b == 0x95)                 // platform - shoot left
                        DrawBlock(g, 16 + 11, jobNr);
                    else if (b == 0x91)                 // platform - shoot right
                        DrawBlock(g, 16 + 10, jobNr);
                    else if (b == 0x88)                 // platform - water
                        DrawBlock(g, 16 + 5, jobNr);
                    else if (b == 0x89 || b == 0x8a)                 // platform - water
                        DrawBlock(g, 16 + 6, jobNr);
                    else if (b == 0x84)                 // platform - crack
                        DrawBlock(g, 16 + 4, jobNr);
                    else if (b == 0x8c)                 // platform - skewers
                        DrawBlock(g, 16 + 7, jobNr);
                    else if (b == 0x8d)                 // platform - skewers
                        DrawBlock(g, 16 + 8, jobNr);
                    else if (b == 0x98)                 // platform - solid
                        DrawBlock(g, 16 + 9, jobNr);
                    else if (b == 0x99)                 // platform - movable block
                        DrawBlock(g, 599 + 6 + 16);
                    else if (b == 0x9a)                 // guest room - floor
                        DrawBlock(g, 599 + 6 + 15);

                    else if (b == 0xc0)         // door left
                        DrawBlock(g, 8, jobNr);
                    else if (b == 0xc1)         // door left
                        DrawBlock(g, 10, jobNr);
                    else if (b == 0x9d)         // elevator right
                        DrawBlock(g, 15, jobNr);
                    else if (b == 0xe0)         // door right
                        DrawBlock(g, 12, jobNr);
                    else if (b == 0xe1)         // door right
                        DrawBlock(g, 14, jobNr);
                    else if (b >= 0xd0 && b <= 0xdf)    // door left
                    {
                        DrawBlock(g, 9, jobNr);
                        DrawBlock(g, 0,0, (char)(b <= 0xd9 ? (b - 0xd0 + 48) : (b - 0xda + 65)));
                    }
                    else if (b >= 0xf0 && b <= 0xff)    // door right
                    {
                        DrawBlock(g, 13, jobNr);
                        DrawBlock(g, 0,0, (char)(b<=0xf9 ? (b-0xf0+48) : (b-0xfa+65)));
                    }
                    else if (b >= 0 && b <= 7)          // background standard pattern
                        DrawBlock(g, b, jobNr);
                    else if (b >= 0x10 && b <= 0x1f)          // background special
                        DrawBlock(g, b + 16, jobNr);
                    else if (b >= 0x08 && b <= 0x0b)          // background special 2
                        DrawBlock(g, b + 20, jobNr);
                    else if (b >= 0x0c && b <= 0x0f)          // background special 3
                        DrawBlock(g, b + 36, jobNr);
                    else if (b >= 0x2c && b <= 0x2f)                 // bomb
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 595);
                    }
                    else if (b >= 0x3c && b <= 0x3f)                 // shoes
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 599);
                    }
                    else if (b >= 0x30 && b <= 0x33)                 // hamburger
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 596);
                    }
                    else if (b >= 0x34 && b <= 0x37)                 // candy
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 597);
                    }
                    else if (b >= 0x28 && b <= 0x2b)                 // water
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 594);
                    }
                    else if (b >= 0x38 && b <= 0x3b)                 // plate cover
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 598);
                    }
                    else if (b >= 0x24 && b <= 0x27)                 // anti poison
                    {
                        DrawBlock(g, bg, jobNr);
                        DrawBlock(g, 593);
                    }
                    else if (b >= 0x40 && b <= 0x47)                 // guest room - bg
                        DrawBlock(g, b + 576 - 0x40);
                    else if (b >= 0x48 && b <= 0x4b)                 // guest room - window
                        DrawBlock(g, b + 576 + 8 - 0x48);
                    else if (b >= 0x4c && b <= 0x4f)                 // guest room - painting
                        DrawBlock(g, b + 576 + 12 - 0x4c);
                    else if (b >= 0x58 && b <= 0x5f)                 // guest room - big cupboard
                        DrawBlock(g, b + 576 + 32 - 0x58);
                    else if (b >= 0x54 && b <= 0x57)                 // guest room - plant cupboard
                        DrawBlock(g, b + 576 + 28 - 0x54);
                    else if (b >= 0x50 && b <= 0x53)                 // guest room - small cupboard
                        DrawBlock(g, b + 576 + 24 - 0x50);
                    else if (b >= 0x60 && b <= 0x6b)                 // guest room - guest with table
                        DrawBlock(g, b - 0x60 + 68, jobNr);

                }

            }

            // put Franc on the start position
            int offset = (_levelData[0x3069] + _levelData[0x306a] * 256) - 0x4000 - 16;
            _x = offset % 16;
            _y = offset / 16;
            DrawBlock(g, 640);
            _y++; DrawBlock(g, 640 + 16);
            _y++; DrawBlock(g, 640 + 32);

            // put water drops, skewers, bullets
            for (int row = 0; row < 768; row++) // second pass
            {
                for (int i = 0; i < 16; i++)
                {
                    _x = i;
                    _y = row;
                    int b = _levelData[row * 16 + i + 7];
                    if (b == 0x88 || b == 0x89 || b == 0x8a)         // platform - water
                    {
                        _y++; DrawBlock(g, 643); _y--;  // water drop
                    }
                    else if (b == 0x8c || b == 0x8d)                 // platform - skewers
                    {
                        _y--; DrawBlock(g, 645 + 16);  // skewers
                        _y--; DrawBlock(g, 645); _y += 2; // skewers
                    }
                    else if (b == 0x95)                 // platform - shoot left
                    {
                        _x--; DrawBlock(g, 642); _x++;  // bullet left
                    }
                    else if (b == 0x91)                 // platform - shoot right
                    {
                        _x++; DrawBlock(g, 641); _x--;  // bullet right
                    }

                }
            }


            // place all birds,poisonous animals, jumping animals, spiders, digging animals, elevators


            SortedList<int, int> sortedList = new SortedList<int, int>();

            offset = 0x3366;// (_levelData[0x3069] + _levelData[0x306a] * 256) - 0x4000 - 16;
            while (true)
            {
                if (_levelData[offset] == 0 && _levelData[offset + 1] == 0xc0 && _levelData[offset + 2] == 0xec && _levelData[offset + 3] == 0 && _levelData[offset + 4] == 0)
                    break;
                int addr = (_levelData[offset] + _levelData[offset + 1] * 256) - 0x4000;
                int type = _levelData[offset+3];
                int extra = _levelData[offset + 4];
                _x = addr % 16;
                _y = addr / 16;

                switch (type)
                {
                    case 1: //bird
                        DrawBlock(g, 640+12);
                        int x1 = _x;
                        int x2 = _x = extra % 16;
                        DrawBlock(g, 640+12);
                        if (x1 > x2) { int z = x1; x1 = x2; x2 = z; } // x1 must be less than x2
                        for (_x = x1 + 1; _x < x2; _x++)
                            DrawBlock(g, 640 + 14); // draw little dots
                        break;
                    case 2: // poisonous animal
                        DrawBlock(g, 640+10);
                        break;
                    case 3: // jumping animal
                        DrawBlock(g, 640+11);
                        break;
                    case 4: // spider
                        //1598
                        if (jobNr == 3 && addr == 1598) break;  // error in job-file
                        DrawBlock(g, 640+7);
                        //if (_x == 14)
                        //{
                        //    int hh = 1;
                        //}
                        break;
                    case 5: // digger
                        if (jobNr == 5 && addr == 6193) _x++; // error in job-file
                        DrawBlock(g, 640+13);
                        break;
                    case 6: // elevator
                    case 7: // elevator
                        DrawBlock(g, 640 + 8);
                        bool isVert = ((extra & 64) == 64);
                        bool isUpOrToLeft = ((extra & 128) == 128);
                        int cnt = (extra & 63);
                        while (cnt>0)
                        {
                            cnt--;
                            if (isVert)
                                if (isUpOrToLeft) _y--; else _y++;
                            else
                                if (isUpOrToLeft) _x--; else _x++;
                            int key = (_y * 16) + _x;
                            if (sortedList.ContainsKey(key)) continue;
                            sortedList.Add(key, 0);
                            if (cnt==0)
                                DrawBlock(g, 640 + 8);
                            else
                                DrawBlock(g, 640 + 14 + (isVert ? 16 : 0));
                        }
                        break;                        
                }
                offset += 5; // next animal/elevator
            }


            // extra message in Job 6 (final)
            if (jobNr==6)
            {
                //1984
                _x = 24;
                _y = 1986;
                g.FillRectangle(new SolidBrush(Color.Black), new Rectangle(22, 1986, 468, 18));
                DrawText(g, "BLOW OPENING AT THE LEFT SIDE");
            }


            _x = 168;
            _y = 24;
            DrawText(g, "BEGIN / TOP");

            _x = 776-32;
            _y = 4;
            DrawText(g, "CONTINUE");
            DrawBlockSub(g, 176, 16, 1);
            DrawBlockSub(g, 177, 16, 2);
            DrawBlockSub(g, 160, 16, 0);
            DrawBlockSub(g, 161, 17, 0);
            DrawBlockSub(g, 162, 18, 0);
            DrawBlockSub(g, 162, 19, 0);
            DrawBlockSub(g, 162, 20, 0);
            DrawBlockSub(g, 162, 21, 0);
            DrawBlockSub(g, 163, 22, 0);
            _x = 776 -32 + (17 * 32);
            DrawText(g, "CONTINUE");
            DrawBlockSub(g, 176, 16 + 17, 1);
            DrawBlockSub(g, 177, 16 + 17, 2);
            DrawBlockSub(g, 160, 16 + 17, 0);
            DrawBlockSub(g, 161, 17 + 17, 0);
            DrawBlockSub(g, 162, 18 + 17, 0);
            DrawBlockSub(g, 162, 19 + 17, 0);
            DrawBlockSub(g, 162, 20 + 17, 0);
            DrawBlockSub(g, 162, 21 + 17, 0);
            DrawBlockSub(g, 163, 22 + 17, 0);


            _x = 216;
            _y = 8300;
            DrawText(g, "CONTINUE");
            DrawBlockSub(g, 178, 11, 259);
            DrawBlockSub(g, 178, 12, 259);
            DrawBlockSub(g, 178, 13, 259);
            DrawBlockSub(g, 178, 14, 259);
            DrawBlockSub(g, 178, 15, 259);
            DrawBlockSub(g, 179, 16, 259);
            _x = 216 + (17*32);
            DrawText(g, "CONTINUE");
            DrawBlockSub(g, 178, 11 + 17, 259);
            DrawBlockSub(g, 178, 12 + 17, 259);
            DrawBlockSub(g, 178, 13 + 17, 259);
            DrawBlockSub(g, 178, 14 + 17, 259);
            DrawBlockSub(g, 178, 15 + 17, 259);
            DrawBlockSub(g, 179, 16 + 17, 259);

            // Clean up
            g.Dispose();
        }

        private void DrawText(Graphics g, string txt)
        {
            int idx;
            for (int i = 0; i < txt.Length; i++)
            {
                idx = (int)txt[i] - 65 + 2529;
                g.DrawImage(_tilesImg, _x, _y, new Rectangle((idx % 32) * 16, (idx / 32) * 16, 15, 15), GraphicsUnit.Pixel);
                _x += 16;
            }
        }
        private void DrawBlock(Graphics g, int idx, int jobNr = 0, char chr = '\0')
        {
            int z = _y;
            if (z >= (_limit1 + 12) && z < _limit2) return;
            if (z >= _limit2) z -= (_limit2-(_limit1+12));

            int x = _x + (z / 256) * 17;
            int y = (z % 256) + 2;


            if (jobNr > 0) idx += ((jobNr - 1) * 96);
            if (chr == '\0')
                DrawBlockSub(g, idx, x, y);
            else
                DrawBlockSubChar(g, chr, x, y);
            if (z == 254 || z == 255 || z == 510 || z == 511)
            {
                if (chr == '\0')
                    DrawBlockSub(g, idx, x + 17, y - 256);
                else
                    DrawBlockSubChar(g, chr, x + 17, y - 256);
                if (z == 254 || z == 510)
                    DrawBlockSub(g, 67, x + 17, y - 256);
                else
                    DrawBlockSub(g, 67 + 16, x + 17, y - 256);

            }
            else if (z == 256 || z == 257 || z == 512 || z == 513)
            {
                if (chr == '\0')
                    DrawBlockSub(g, idx, x - 17, y + 256);
                else
                    DrawBlockSubChar(g, chr, x - 17, y + 256);
                if (z == 256 || z == 512)
                    DrawBlockSub(g, 66, x - 17, y + 256);
                else
                    DrawBlockSub(g, 66 + 16, x - 17, y + 256);
            }

        }
        private void DrawBlockSub(Graphics g, int idx, int x, int y)
        {
            x *= 32;
            y *= 32;
            g.DrawImage(_tilesImg, x, y, new Rectangle((idx % 16) * 32, (idx / 16) * 32, 31, 31), GraphicsUnit.Pixel);

        }
        private void DrawBlockSubChar(Graphics g, char c, int x, int y)
        {
            x *= 32;x += 8;
            y *= 32;y += 8;
            int idx = (int)c - 65 + 2529;
            g.FillRectangle(new SolidBrush(Color.Black), new Rectangle(x-3, y-3, 20, 20));
            g.DrawImage(_tilesImg, x, y, new Rectangle((idx % 32) * 16, (idx / 32) * 16, 15, 15), GraphicsUnit.Pixel);

        }



        private int getXoffset(int addrStart)
        {
            int x = 31;
            int rightEmptyCols = 0;
            
            while (true)
            {
                for (int i=0;i<(14*32); i+=32)
                {
                    if (_levelData[addrStart + x + i] != 0)
                        return rightEmptyCols / 2;
                }
                x -= 1;
                rightEmptyCols++;
            }
        }




    }
}
