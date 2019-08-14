Attribute VB_Name = "FinderPattern"
'---------------------------------------------------------------------------
' �ʒu���o�p�^�[��
'---------------------------------------------------------------------------
Option Private Module
Option Explicit


Private m_finderPattern() As Variant
Private m_initialized As Boolean

'--------------------------------------------------------------------------------
' (�T�v)
'  �ʒu���o�p�^�[����z�u���܂��B
'--------------------------------------------------------------------------------
Public Sub Place(ByRef moduleMatrix() As Variant)
    Call Init

    Dim offset As Long
    offset = (UBound(moduleMatrix) + 1) - (UBound(m_finderPattern) + 1)

    Dim i As Long
    Dim j As Long
    Dim v As Long

    For i = 0 To UBound(m_finderPattern)
        For j = 0 To UBound(m_finderPattern(i))
            v = m_finderPattern(i)(j)

            moduleMatrix(i)(j) = v
            moduleMatrix(i)(j + offset) = v
            moduleMatrix(i + offset)(j) = v
        Next
    Next
End Sub

'------------------------------------------------------------------------------
' (�T�v)
'  �I�u�W�F�N�g�����������܂��B
'------------------------------------------------------------------------------
Private Sub Init()
    If m_initialized Then Exit Sub

    m_initialized = True

   ' �ʒu���o�p�^�[��
    m_finderPattern = Array( _
        Array(2, 2, 2, 2, 2, 2, 2), _
        Array(2, -2, -2, -2, -2, -2, 2), _
        Array(2, -2, 2, 2, 2, -2, 2), _
        Array(2, -2, 2, 2, 2, -2, 2), _
        Array(2, -2, 2, 2, 2, -2, 2), _
        Array(2, -2, -2, -2, -2, -2, 2), _
        Array(2, 2, 2, 2, 2, 2, 2) _
    )
End Sub
