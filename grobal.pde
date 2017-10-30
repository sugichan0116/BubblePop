import controlP5.*;
ControlP5 cp5;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;

import ddf.minim.*;

Minim minim;
AudioPlayer snd[];

ArrayList stage;
ArrayList History;
int currentHistory;
boolean isValidHistory;
String[] reader;
String[] fileOver;

int playStage = 0;
int mode = 0;
int stageRank = 0;

Space space;
int selected = -1;
float dragX, dragY;
int AnimeSlide = 0;
int AnimeClear = 0;
int MoveID = -1, MoveDirection = -1;
boolean mouseOver = false;
int HintTime = 0;
int HintID = 0;

int AnimeMenuLeft = 0, AnimeMenuRight = 0;
float menuRadius = 64f;
boolean isOverMenuLeft = false, isOverMenuRight = false;

int AnimeTitle = 0;
float arrayX[] = { .2f, .5f, .8f, .35f, .65f, .2f, .5f, .8f };
float arrayY[] = { .4f, .4f, .4f, .6f, .6f, .8f, .8f, .8f };
String seas[] = { "Blue Sea", "Green Sea", "Red Sea", "Black Sea" };
String seasDescription[] = { "For Beginner & Normal Bubble",
  "A Little Difficult & Turned Bubble Join!",
  "Complex Puzzle & Locked Bubble Join!",
  "Extra Stage & Free Edit" };
color seaColor[] = { color(0, 100, 200), color(0, 200, 60), color(200, 50, 20), color(50, 50, 50) };
color seaWideColor[] = { color(0, 40, 30), color(0, 30, 40), color(20, 20, 10), color(50, 50, 50) };
int selectSea = 0;
int seaSlide = 0;
boolean isOverSea = false;
int titleShift = 0;

Space Edit;
color LowColor, HighColor;
boolean whichColor = false;
int RedBar, GreenBar, BlueBar;
int BubbleMode = 0;
int BubbleNumber = 1;
String Title = "";
Space Board;
Space Select;
boolean isEdit = false;
boolean isTest = false;

float RateX, RateY;
int screenPreWidth = 0, screenPreHeight = 0;
int StageAction = 0;
String[] StageActionDescription = {"Play to Select", "Edit to Select", "Shift Right", "Shift Left", "Remove to Select"};
int SavedAnime = 0;

PImage[] help;
int helpPoint = 0;

boolean isDebug = false;

int mouseStop = 0;
int mouseStopX, mouseStopY;