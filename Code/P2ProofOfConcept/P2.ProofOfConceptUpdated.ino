const int pinArray[] = {A0, A1, A2, A3}; //storing the four analog pins in array so we can use for loop to iterate over them - analog to read diff voltages
const int tolerance = 10; //how much we allow voltage to vary for building, small number so voltages of different buildings dont overlap
const int num_squares = 4; // number of building squares
const int num_buildings = 4; // number of buildings

int boardState[num_squares]; //empty array
const int buildingVoltages[] = {446, 493, 536, 625}; // array of 


void setup() {
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  for(int squareIndex = 0; squareIndex < num_squares; squareIndex++) { //for each square in the array
    int inputVoltage = analogRead(pinArray[squareIndex]); // find voltage output from that square
    // find corresponding building to output voltage
    int correspondingBuilding = -1; //-1 if no associated building
    for(int buildingIndex = 0; buildingIndex < num_buildings; buildingIndex++) { //for each building voltage, checking to see if voltage falls within tolerance
      if (abs(buildingVoltages[buildingIndex] - inputVoltage) < tolerance) {
        correspondingBuilding = buildingIndex; // assigns building value based on which building is within the tolerance, iterating over all the buildings
        break; // break loop once all buildings are identified
      }
    }
    boardState[squareIndex] = correspondingBuilding; //current square on the board is assigned the found building
  }
  //prints array to serial
  Serial.print("ArrayState:");
  for(int i = 0; i < num_squares; i++){
    //Serial.print("You have just placed ");
    Serial.print(" ");
    Serial.print(boardState[i]+1); // displays the numebr of the building placed,
    //Serial.print(" on the board!");
  }
  Serial.println(); // prints to new line
}


