import * as React from 'react'
import { useEffect, useState, useRef } from 'react'
import * as ReactDom from 'react-dom'

const Cursor = () => {
    return (
        <span className="animate-pulse text-indigo-500 font-bold"> | </span>
    )
}

const TypeWritter = ({text = null}) => {
    if (text === null) return <Cursor />
    const [textLength, setTextLength] = useState(0)
    const interval = useRef(0)

    useEffect(() => {
        interval.current = setInterval(() => {
            setTextLength(textLength => textLength + 1)
        }, 30);
        return () => clearInterval(interval.current)
    }, [text])

    if (textLength == text.length) {
        clearInterval(interval.current)
    }

    return (
        <span>{text.substring(0, textLength)}</span>
    )
}

export default TypeWritter
