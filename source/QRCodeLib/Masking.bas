Attribute VB_Name = "Masking"
'------------------------------------------------------------------------------
' �}�X�N
'------------------------------------------------------------------------------
Option Private Module
Option Explicit

'------------------------------------------------------------------------------
' (�T�v)
'  �}�X�N��K�p���܂��B
'
' (�p�����[�^)
'  moduleMatrix : �V���{���̖��Ãp�^�[��
'  ver          : �^��
'  ecLevel      : ���������x��
'
' (�߂�l)
'  �K�p���ꂽ�}�X�N�p�^�[���Q�Ǝq
'------------------------------------------------------------------------------
Public Function Apply(ByRef moduleMatrix() As Variant, _
                      ByVal ver As Long, _
                      ByVal ecLevel As ErrorCorrectionLevel) As Long

    Dim maskPatternReference As Long
    maskPatternReference = SelectMaskPattern(moduleMatrix, ver, ecLevel)
    Call Mask(moduleMatrix, maskPatternReference)

    Apply = maskPatternReference

End Function

'------------------------------------------------------------------------------
' (�T�v)
'  �}�X�N�p�^�[�������肵�܂��B
'
' (�p�����[�^)
'  moduleMatrix : �V���{���̖��Ãp�^�[��
'  ver          : �^��
'  ecLevel      : ���������x��
'
' (�߂�l)
'  �}�X�N�p�^�[���Q�Ǝq
'------------------------------------------------------------------------------
Private Function SelectMaskPattern(ByRef moduleMatrix() As Variant, _
                                   ByVal ver As Long, _
                                   ByVal ecLevel As ErrorCorrectionLevel) As Long

    Dim minPenalty As Long
    minPenalty = &H7FFFFFFF

    Dim ret As Long
    ret = 0

    Dim temp()  As Variant
    Dim penalty As Long
    Dim maskPatternReference As Long

    For maskPatternReference = 0 To 7
        temp = moduleMatrix

        Call Mask(temp, maskPatternReference)

        Call FormatInfo.Place(temp, ecLevel, maskPatternReference)

        If ver >= 7 Then
            Call VersionInfo.Place(temp, ver)
        End If

        penalty = MaskingPenaltyScore.CalcTotal(temp)

        If penalty < minPenalty Then
            minPenalty = penalty
            ret = maskPatternReference
        End If
    Next

    SelectMaskPattern = ret

End Function


'------------------------------------------------------------------------------
' (�T�v)
'  �}�X�N�p�^�[����K�p�����V���{���f�[�^��Ԃ��܂��B
'
' (�p�����[�^)
'  moduleMatrix()       : �V���{���̖��Ãp�^�[��
'  maskPatternReference : �}�X�N�p�^�[���Q�Ǝq��\��0����7�܂ł̒l
'------------------------------------------------------------------------------
Private Sub Mask(ByRef moduleMatrix() As Variant, ByVal maskPatternReference As Long)

    Dim condition As IMaskingCondition
    Set condition = GetCondition(maskPatternReference)

    Dim r As Long
    Dim c As Long

    For r = 0 To UBound(moduleMatrix)
        For c = 0 To UBound(moduleMatrix(r))
            If Math.Abs(moduleMatrix(r)(c)) = 1 Then
                If condition.Evaluate(r, c) Then
                    moduleMatrix(r)(c) = moduleMatrix(r)(c) * -1
                End If
            End If
        Next
    Next

End Sub

'------------------------------------------------------------------------------
' (�T�v)
'  �}�X�N������Ԃ��܂��B
'------------------------------------------------------------------------------
Private Function GetCondition(ByVal maskPatternReference As Long) As IMaskingCondition

    Dim ret As IMaskingCondition

    Select Case maskPatternReference
        Case 0
            Set ret = New Masking0Condition

        Case 1
            Set ret = New Masking1Condition

        Case 2
            Set ret = New Masking2Condition

        Case 3
            Set ret = New Masking3Condition

        Case 4
            Set ret = New Masking4Condition

        Case 5
            Set ret = New Masking5Condition

        Case 6
            Set ret = New Masking6Condition

        Case 7
            Set ret = New Masking7Condition

        Case Else
            Call Err.Raise(5)

    End Select

    Set GetCondition = ret

End Function
