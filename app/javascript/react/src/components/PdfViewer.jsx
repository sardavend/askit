import * as React from 'react'
import * as ReactDom from 'react-dom'
import { Worker, Viewer} from '@react-pdf-viewer/core'

const PdfViewer = ({encodedFile}) => {

  const toBlob = (stringData) => {
    const base64WithoutPrefix = stringData.substr('data:application/pdf;base64,'.length);
    const bytes = atob(base64WithoutPrefix);
    let length = bytes.length;
    let out = new Uint8Array(length);

    while (length--) {
        out[length] = bytes.charCodeAt(length);
    }
    return new Blob([out], { type: 'application/pdf' });
  }

  const blob = toBlob(encodedFile)
  const url = URL.createObjectURL(blob)

  return(
    <Worker workerUrl="https://unpkg.com/pdfjs-dist@3.4.120/build/pdf.worker.min.js">
      <div className='overflow-hidden' style={{
        height: '750px',
      }}>
        <Viewer fileUrl={url} />
      </div>
    </Worker>
  )

}

export default PdfViewer
