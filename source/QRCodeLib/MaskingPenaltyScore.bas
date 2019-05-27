Attribute VB_Name = "MaskingPenaltyScore"
'------------------------------------------------------------------------------
' �}�X�N���ꂽ�V���{���̎��_�]��
'------------------------------------------------------------------------------
Option Private Module
Option Explicit

'------------------------------------------------------------------------------
' (�T�v)
'  �}�X�N�p�^�[�����_�̍��v��Ԃ��܂��B
'------------------------------------------------------------------------------
Public Function CalcTotal(ByRef moduleMatrix() As Variant) As Long

    Dim total   As Long
    Dim penalty As Long

    penalty = CalcAdjacentModulesInSameColor(moduleMatrix)
    total = total + penalty

    penalty = CalcBlockOfModulesInSameColor(moduleMatrix)
    total = total + penalty

    penalty = CalcModuleRatio(moduleMatrix)
    total = total + penalty

    penalty = CalcProportionOfDarkModules(moduleMatrix)
    total = total + penalty

    CalcTotal = total

End Function


'------------------------------------------------------------------------------
' (�T�v)
'  �s�^��̓��F�אڃ��W���[���p�^�[���̎��_���v�Z���܂��B
'------------------------------------------------------------------------------
Private Function CalcAdjacentModulesInSameColor(ByRef moduleMatrix() As Variant) As Long

    Dim penalty As Long
    penalty = 0

    penalty = penalty + CalcAdjacentModulesInRowInSameColor(moduleMatrix)
    penalty = penalty + CalcAdjacentModulesInRowInSameColor(MatrixRotate90(moduleMatrix))

    CalcAdjacentModulesInSameColor = penalty

End Function

'------------------------------------------------------------------------------
' (�T�v)
'  �s�̓��F�אڃ��W���[���p�^�[���̎��_���v�Z���܂��B
'------------------------------------------------------------------------------
Private Function CalcAdjacentModulesInRowInSameColor(ByRef moduleMatrix() As Variant) As Long

    Dim penalty As Long
    penalty = 0

    Dim rowArray As Variant
    Dim i As Long
    Dim cnt As Long

    For Each rowArray In moduleMatrix
        cnt = 1

        For i = 0 To UBound(rowArray) - 1
            If (rowArray(i) > 0) = (rowArray(i + 1) > 0) Then
                cnt = cnt + 1
            Else
                If cnt >= 5 Then
                    penalty = penalty + (3 + (cnt - 5))
                End If

                cnt = 1
            End If
        Next

        If cnt >= 5 Then
            penalty = penalty + (3 + (cnt - 5))
        End If
    Next

    CalcAdjacentModulesInRowInSameColor = penalty

End Function

'------------------------------------------------------------------------------
' (�T�v)
'  2x2�̓��F���W���[���p�^�[���̎��_���v�Z���܂��B
'------------------------------------------------------------------------------
Private Function CalcBlockOfModulesInSameColor(ByRef moduleMatrix() As Variant) As Long

    Dim penalty     As Long
    Dim isSameColor As Boolean
    Dim r           As Long
    Dim c           As Long
    Dim temp        As Boolean

    For r = 0 To UBound(moduleMatrix) - 1
        For c = 0 To UBound(moduleMatrix(r)) - 1
            temp = moduleMatrix(r)(c) > 0
            isSameColor = True

            isSameColor = isSameColor And (moduleMatrix(r + 0)(c + 1) > 0 = temp)
            isSameColor = isSameColor And (moduleMatrix(r + 1)(c + 0) > 0 = temp)
            isSameColor = isSameColor And (moduleMatrix(r + 1)(c + 1) > 0 = temp)

            If isSameColor Then
                penalty = penalty + 3
            End If
        Next
    Next

    CalcBlockOfModulesInSameColor = penalty

End Function

'------------------------------------------------------------------------------
' (�T�v)
'  �s�^��ɂ�����1 : 1 : 3 : 1 : 1 �䗦�p�^�[���̎��_���v�Z���܂��B
'------------------------------------------------------------------------------
Private Function CalcModuleRatio(ByRef moduleMatrix() As Variant) As Long

    Dim moduleMatrixTemp() As Variant
    moduleMatrixTemp = QuietZone.Place(moduleMatrix)

    Dim penalty As Long
    penalty = 0

    penalty = penalty + CalcModuleRatioInRow(moduleMatrixTemp)
    penalty = penalty + CalcModuleRatioInRow(MatrixRotate90(moduleMatrixTemp))

    CalcModuleRatio = penalty

End Function


'------------------------------------------------------------------------------
' (�T�v)
'  �s��1 : 1 : 3 : 1 : 1 �䗦�̃p�^�[����]�����A���_��Ԃ��܂��B
'------------------------------------------------------------------------------
Private Function CalcModuleRatioInRow(ByRef moduleMatrix() As Variant) As Long

    Dim penalty As Long

    Dim ratio3Ranges As Collection
    Dim rowArray As Variant

    Dim ratio1 As Long
    Dim ratio3 As Long
    Dim ratio4 As Long

    Dim i As Long
    Dim cnt As Long
    Dim impose As Boolean

    Dim rng As Variant

    For Each rowArray In moduleMatrix
        Set ratio3Ranges = GetRatio3Ranges(rowArray)

        For Each rng In ratio3Ranges
            ratio3 = rng(1) + 1 - rng(0)
            ratio1 = ratio3 \ 3
            ratio4 = ratio1 * 4
            impose = False

            ' light ratio 1
            i = rng(0) - 1
            cnt = 0
            Do While i > 0
                If rowArray(i) <= 0 And rowArray(i - 1) > 0 Then
                    cnt = cnt + 1
                    i = i - 1
                Else
                    Exit Do
                End If
            Loop

            If cnt <> ratio1 Then GoTo Continue

            ' dark ratio 1
            cnt = 0
            Do While i > 0
                If rowArray(i) > 0 And rowArray(i - 1) <= 0 Then
                    cnt = cnt + 1
                    i = i - 1
                Else
                    Exit Do
                End If
            Loop

            If cnt <> ratio1 Then GoTo Continue

            ' light ratio 4
            cnt = 0
            Do While i >= 0
                If rowArray(i) <= 0 Then
                    cnt = cnt + 1
                    i = i - 1
                Else
                    Exit Do
                End If
            Loop

            If cnt >= ratio4 Then
                impose = True
            End If

            ' light ratio 1
            i = rng(1) + 1
            cnt = 0
            Do While i < UBound(rowArray)
                If rowArray(i) <= 0 And rowArray(i + 1) > 0 Then
                    cnt = cnt + 1
                    i = i + 1
                Else
                    Exit Do
                End If
            Loop

            If cnt <> ratio1 Then GoTo Continue

            ' dark ratio 1
            cnt = 0
            Do While i < UBound(rowArray)
                If rowArray(i) > 0 And rowArray(i - 1) <= 0 Then
                    cnt = cnt + 1
                    i = i + 1
                Else
                    Exit Do
                End If
            Loop

            If cnt <> ratio1 Then GoTo Continue

            ' light ratio 4
            cnt = 0
            Do While i <= UBound(rowArray)
                If rowArray(i) <= 0 Then
                    cnt = cnt + 1
                    i = i + 1
                Else
                    Exit Do
                End If
            Loop

            If cnt >= ratio4 Then
                impose = True
            End If

            If impose Then
                penalty = penalty + 40
            End If
Continue:
        Next
    Next

    CalcModuleRatioInRow = penalty

End Function

Private Function GetRatio3Ranges(ByRef arg As Variant) As Collection

    Dim ret As Collection
    Set ret = New Collection

    Dim s As Long
    Dim e As Long

    Dim i As Long

    For i = 4 To UBound(arg) - 4
        If arg(i) > 0 And arg(i - 1) <= 0 Then
            s = i
        End If

        If arg(i) > 0 And arg(i + 1) <= 0 Then
            e = i

            If (e + 1 - s) Mod 3 = 0 Then
                Call ret.Add(Array(s, e))
            End If
        End If
    Next

    Set GetRatio3Ranges = ret

End Function


'------------------------------------------------------------------------------
' (�T�v)
'  �S�̂ɑ΂���Ã��W���[���̐�߂銄���ɂ��Ď��_���v�Z���܂��B
'------------------------------------------------------------------------------
Private Function CalcProportionOfDarkModules(ByRef moduleMatrix() As Variant) As Long

    Dim darkCount As Long

    Dim r As Long
    Dim c As Long

    For r = 0 To UBound(moduleMatrix)
        For c = 0 To UBound(moduleMatrix(r))
            If moduleMatrix(r)(c) > 0 Then
                darkCount = darkCount + 1
            End If
        Next
    Next

    Dim numModules As Double
    numModules = (UBound(moduleMatrix) + 1) ^ 2

    Dim temp As Long
    temp = Int((darkCount / numModules * 100) + 1)
    temp = Abs(temp - 50)
    temp = (temp + 4) \ 5

    CalcProportionOfDarkModules = temp * 10

End Function

'------------------------------------------------------------------------------
' (�T�v)
'  ����90�x��]�����z���Ԃ��܂��B
'------------------------------------------------------------------------------
Private Function MatrixRotate90(ByRef arg() As Variant) As Variant()

    Dim ret() As Variant
    ReDim ret(UBound(arg(0)))

    Dim i As Long
    Dim j As Long
    Dim cols() As Long

    For i = 0 To UBound(ret)
        ReDim cols(UBound(arg))
        ret(i) = cols
    Next

    Dim k As Long
    k = UBound(ret)

    For i = 0 To UBound(ret)
        For j = 0 To UBound(ret(i))
            ret(i)(j) = arg(j)(k - i)
        Next
    Next

    MatrixRotate90 = ret

End Function

