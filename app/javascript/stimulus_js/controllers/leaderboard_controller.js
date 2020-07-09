import { Controller } from "stimulus"
import { pauseAndPlay } from '../helpers/videos_helper'

export default class extends Controller {
  connect() {
    pauseAndPlay();
  }
}
