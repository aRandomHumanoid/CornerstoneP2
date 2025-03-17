const int numSquares = 4;
const int pins[] = {1, 2, 3, 4};

const int numBuildings = 5;
const int buildingVoltages[] = {10, 20, 30, 40, 50};

const int tolerance = 5;

int boardState[numSquares];

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  for(int squareIndex = 0; squareIndex < numSquares; squareIndex++) {
    int inputVoltage = analogRead(pins[squareIndex]);
    int correspondingBuilding = -1;
    for(int buildingIndex = 0; buildingIndex < numBuildings; buildingIndex++) {
      if (abs(buildingVoltages[buildingIndex] - inputVoltage) < tolerance) {
        correspondingBuilding = buildingIndex;
        break;
      }
    }
    boardState[squareIndex] = correspondingBuilding;
  }
  Serial.print("ArrayState:");
  for(int i = 0; i < boardState; i++){
    Serial.print(" ");
    Serial.print(boardState[i]);
  }
  Serial.println();
}
