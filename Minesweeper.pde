import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 24;
public final static int NUM_COLS = 24;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
private int bombLimit;
private boolean lost;
void setup ()
{
    size(576, 576);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make(this);
    bombLimit = 99;
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0; r<buttons.length; r++)
    {
        for(int c=0; c<buttons[r].length; c++)
        {
            buttons[r][c]= new MSButton(r,c);
        }
    }
    bombs = new ArrayList <MSButton>();
    //declare and initialize buttons
    for(int i=0; i<bombLimit; i++)
    {
        setBombs();
    }
    lost=false;
}
public void setBombs()
{
    //your code
    int rowRand = (int)(Math.random()*24);
    int colRand = (int)(Math.random()*24);
    if(!bombs.contains(buttons[rowRand][colRand]))
    {
        bombs.add(buttons[rowRand][colRand]);
    }
    else
    {
        bombLimit++;
    }
}
public void draw()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
    for(int r=0; r<buttons.length; r++)
    {
        for(int c=0; c<buttons[r].length; c++)
        {
            if(bombs.contains(buttons[r][c]) && buttons[r][c].isClicked())
            {
                displayLosingMessage();
            }
        }
    }
}
public boolean isWon()
{
    //your code here
    int noMine = 0;
    for(int r=0; r<NUM_ROWS; r++)
    {
        for(int c=0; c<NUM_COLS; c++)
        {
            if(!bombs.contains(buttons[r][c]) && buttons[r][c].isClicked())
            {
                noMine++;
            }
        }
    }
    if(noMine==(NUM_COLS*NUM_ROWS)-bombLimit)
        return true;
    else
        return false;
}
public void displayLosingMessage()
{
    //your code here
    String loseMessage = "A loser is you!!";
    for(int c=5; c<loseMessage.length()+5; c++)
    {
        buttons[12][c].setLabel(loseMessage.substring(c-5,c-4));
    }
    for(int r=0; r<buttons.length; r++)
    {
        for(int c=0; c<buttons[r].length; c++)
        {
            if(bombs.contains(buttons[r][c])&&!buttons[r][c].isClicked())
            {
                buttons[r][c].mousePressed();
            }
        }
    }
    lost=true;
}
public void displayWinningMessage()
{
    //your code here
    String winMessage = "A winner is you!";
    for(int c=5; c<winMessage.length()+5; c++)
    {
        buttons[12][c].setLabel(winMessage.substring(c-5,c-4));
    }
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 576/NUM_COLS;
        height = 576/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    public void mousePressed() 
    {
        if(mouseButton==LEFT && !buttons[r][c].isMarked())
        {
            clicked = true;
        }
        if(mouseButton==RIGHT && !buttons[r][c].isClicked())
        {
            marked = !marked;
        }
        else if(countBombs(r,c)>0)
        {
            label = ""+countBombs(r,c);
            if(bombs.contains(buttons[r][c]))
            {
                label = "";
            }
        }
        else
        {
            if(!bombs.contains(buttons[r][c]))
            {
                if(isValid(r,c+1)&&buttons[r][c+1].isClicked()==false){buttons[r][c+1].mousePressed();}
                if(isValid(r-1,c+1)&&buttons[r-1][c+1].isClicked()==false){buttons[r-1][c+1].mousePressed();}
                if(isValid(r-1,c)&&buttons[r-1][c].isClicked()==false){buttons[r-1][c].mousePressed();}
                if(isValid(r-1,c-1)&&buttons[r-1][c-1].isClicked()==false){buttons[r-1][c-1].mousePressed();}
                if(isValid(r,c-1)&&buttons[r][c-1].isClicked()==false){buttons[r][c-1].mousePressed();}
                if(isValid(r+1,c-1)&&buttons[r+1][c-1].isClicked()==false){buttons[r+1][c-1].mousePressed();}
                if(isValid(r+1,c)&&buttons[r+1][c].isClicked()==false){buttons[r+1][c].mousePressed();}
                if(isValid(r+1,c+1)&&buttons[r+1][c+1].isClicked()==false){buttons[r+1][c+1].mousePressed();}
            }
        }
        //your code here
    }
    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(r<NUM_ROWS&&c<NUM_COLS&&r>=0&&c>=0)
        {
            return true;
        }
        else{return false;}
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        //your code here
        if(isValid(row,col+1)&&bombs.contains(buttons[row][col+1])){numBombs++;}
        if(isValid(row-1,col+1)&&bombs.contains(buttons[row-1][col+1])){numBombs++;}
        if(isValid(row-1,col)&&bombs.contains(buttons[row-1][col])){numBombs++;}
        if(isValid(row-1,col-1)&&bombs.contains(buttons[row-1][col-1])){numBombs++;}
        if(isValid(row,col-1)&&bombs.contains(buttons[row][col-1])){numBombs++;}
        if(isValid(row+1,col-1)&&bombs.contains(buttons[row+1][col-1])){numBombs++;}
        if(isValid(row+1,col)&&bombs.contains(buttons[row+1][col])){numBombs++;}
        if(isValid(row+1,col+1)&&bombs.contains(buttons[row+1][col+1])){numBombs++;}
        return numBombs;
    }
}