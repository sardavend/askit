import { define } from 'remount'
import Hello from "./components/Hello"
import PdfViewer from "./components/PdfViewer"
import TypeWritter from './components/Typewritter'

define({
  'ask-it-hello': Hello,
  'ask-it-pdf-viewer': PdfViewer,
  'ask-it-typewritter' : TypeWritter
})
