const int numSquares = 4; //total num of squares;
const int pins[] = {1, 2, 3, 4}; 

const int numBuildings = 5;
const int buildingVoltages[] = {10, 20, 30, 40, 50};

const int tolerance = 5; //tolerance for voltage

int boardState[numSquares]; //boardstate as an array

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); //start serial

}

void loop() {
  // put your main code here, to run repeatedly:
  for(int squareIndex = 0; squareIndex < numSquares; squareIndex++) { //for each square in the array
    int inputVoltage = analogRead(pins[squareIndex]); //find voltage output from that square
    //find corresponding building to output voltage
    int correspondingBuilding = -1; //-1 if no associated building
    for(int buildingIndex = 0; buildingIndex < numBuildings; buildingIndex++) { //for each building voltage
      if (abs(buildingVoltages[buildingIndex] - inputVoltage) < tolerance) {
        correspondingBuilding = buildingIndex; //assigns building
        break;
      }
    }
    boardState[squareIndex] = correspondingBuilding; //current square on the board is assigned the found building
  }
  //prints array to serial
  Serial.print("ArrayState:");
  for(int i = 0; i < boardState; i++){
    Serial.print(" ");
    Serial.print(boardState[i]);
  }
  Serial.println();
}
