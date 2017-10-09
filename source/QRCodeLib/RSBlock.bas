Attribute VB_Name = "RSBlock"
'----------------------------------------------------------------------------------------
' RSブロック
'----------------------------------------------------------------------------------------
Option Private Module
Option Explicit

Private m_totalNumbers() As Variant

Private m_initialized As Boolean

'---------------------------------------------------------------------------
' (概要)
'  RSブロック数を返します。
'  ---------------------------------------------------------------------------
Public Function GetTotalNumber( _
    ByVal ecLevel As ErrorCorrectionLevel, ByVal ver As Long, ByVal preceding As Boolean) As Long

#If [DEBUG] Then
    Debug.Assert ver >= Constants.MIN_VERSION And _
                 ver <= Constants.MAX_VERSION
#End If

    Call Initialize
  
    Dim dataWordCapacity    As Long
    Dim blockCount          As Variant
    
    dataWordCapacity = DataCodeword.GetTotalNumber(ecLevel, ver)
    blockCount = m_totalNumbers(ecLevel)

    If preceding Then
        GetTotalNumber = blockCount(ver) - (dataWordCapacity Mod blockCount(ver))
    Else
        GetTotalNumber = dataWordCapacity Mod blockCount(ver)
    End If

End Function

'---------------------------------------------------------------------------
' (概要)
'  RSブロックのデータコード語数を返します。
'
' (パラメータ)
'  先行するRSブロックは Trueを指定します。
'---------------------------------------------------------------------------
Public Function GetNumberDataCodewords( _
    ByVal ecLevel As ErrorCorrectionLevel, ByVal ver As Long, ByVal preceding As Boolean) As Long

#If [DEBUG] Then
    Debug.Assert ver >= Constants.MIN_VERSION And _
                 ver <= Constants.MAX_VERSION
#End If

    Call Initialize
  
    Dim ret As Long
    
    Dim numDataCodewords As Long
    numDataCodewords = DataCodeword.GetTotalNumber(ecLevel, ver)
    
    Dim numBlocks As Long
    numBlocks = m_totalNumbers(ecLevel)(ver)
    
    Dim numPreBlockCodewords As Long
    numPreBlockCodewords = numDataCodewords \ numBlocks
    
    Dim numPreBlocks As Long
    Dim numFolBlocks As Long
    
    If preceding Then
        ret = numPreBlockCodewords
        
    Else
        numPreBlocks = GetTotalNumber(ecLevel, ver, True)
        numFolBlocks = GetTotalNumber(ecLevel, ver, False)
        
        If numFolBlocks > 0 Then
            ret = (numDataCodewords - numPreBlockCodewords * numPreBlocks) \ numFolBlocks
        Else
            ret = 0
        End If
    End If
    
    GetNumberDataCodewords = ret
    
End Function

'---------------------------------------------------------------------------
' (概要)
'  RSブロックの誤り訂正コード語数を返します。
'---------------------------------------------------------------------------
Public Function GetNumberECCodewords( _
    ByVal ecLevel As ErrorCorrectionLevel, ByVal ver As Long) As Long

#If [DEBUG] Then
    Debug.Assert ver >= Constants.MIN_VERSION And _
                 ver <= Constants.MAX_VERSION
#End If

    Call Initialize
    
    Dim numDataCodewords As Long
    numDataCodewords = DataCodeword.GetTotalNumber(ecLevel, ver)
    
    Dim numBlocks As Long
    numBlocks = m_totalNumbers(ecLevel)(ver)

    GetNumberECCodewords = _
        (Codeword.GetTotalNumber(ver) \ numBlocks) - _
            (numDataCodewords \ numBlocks)

End Function

'----------------------------------------------------------------------------------------
' (概要)
'  オブジェクトを初期化します。
'----------------------------------------------------------------------------------------
Private Sub Initialize()

    If m_initialized Then Exit Sub

    m_initialized = True

    m_totalNumbers = Array( _
        Array(0, _
              1, 1, 1, 1, 1, 2, 2, 2, 2, 4, _
              4, 4, 4, 4, 6, 6, 6, 6, 7, 8, _
              8, 9, 9, 10, 12, 12, 12, 13, 14, 15, _
              16, 17, 18, 19, 19, 20, 21, 22, 24, 25), _
        Array(0, _
              1, 1, 1, 2, 2, 4, 4, 4, 5, 5, _
              5, 8, 9, 9, 10, 10, 11, 13, 14, 16, _
              17, 17, 18, 20, 21, 23, 25, 26, 28, 29, _
              31, 33, 35, 37, 38, 40, 43, 45, 47, 49), _
        Array(0, _
              1, 1, 2, 2, 4, 4, 6, 6, 8, 8, _
              8, 10, 12, 16, 12, 17, 16, 18, 21, 20, _
              23, 23, 25, 27, 29, 34, 34, 35, 38, 40, _
              43, 45, 48, 51, 53, 56, 59, 62, 65, 68), _
        Array(0, _
              1, 1, 2, 4, 4, 4, 5, 6, 8, 8, _
              11, 11, 16, 16, 18, 16, 19, 21, 25, 25, _
              25, 34, 30, 32, 35, 37, 40, 42, 45, 48, _
              51, 54, 57, 60, 63, 66, 70, 74, 77, 81) _
    )
    
End Sub

