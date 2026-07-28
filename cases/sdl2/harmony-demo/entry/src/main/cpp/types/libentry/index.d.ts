export interface GuiState {
  renderReady: boolean;
  frameCount: number;
  buttonClickCount: number;
  sliderValue: number;
  keyboardEventCount: number;
  lastKeyCode: number;
}

export const getGuiState: () => GuiState;
export const resetGuiState: () => void;
